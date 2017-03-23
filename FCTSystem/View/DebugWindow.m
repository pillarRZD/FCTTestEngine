//
//  DebugWindow.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/4.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "DebugWindow.h"
#import "AppConfig.h"
#import "MainBoard.h"
#import "Fixture.h"

#import <sys/ioctl.h>
#import <util.h>
#import <sys/select.h>
#import <unistd.h>

//#import "JKTestScript.h"
//#import "JKBaseDevice.h"
//#import "JKOperation.h"
//#import "JKDeviceManager.h"

#define FUNCFLAG    @"FUNC>"
#define CMDFLAG     @"CMD>"

@interface DebugWindow ()
{
    IBOutlet NSComboBox         *_cbItemIDList;
    IBOutlet NSComboBox         *_cbDevList;
    IBOutlet NSComboBox         *_cbCommandList;
    IBOutlet NSButton           *_btSendCommand;
    
    NSNumber                    *_dutIndex;
    JKTestItem                  *_currentItem;
    NSString                    *_currentItemName;
    JKBaseDevice                *_currentDevice;
    NSString                    *_currentDevName;
    JKOperation                 *_currentOperation;
    NSString                    *_currentCommand;
    
    IBOutlet JKMessageViewController    *_appDisplayer;
    
    BOOL                    _loadFlag;
    NSRegularExpression     *_devIndexRegex;
    
    NSTask          *_terminalTask;
//    NSPipe          *_oPipe;
//    NSPipe          *_iPipe;
//    NSPipe          *_ePipe;
    int fd;
//    int unblockPipeR;
//    int unblockPipeW;
    NSMutableData   *_writeBuffer;
    NSLock          *_writeLock;
    NSFileHandle    *_oHandle;
    NSFileHandle    *_iHandle;
    NSFileHandle    *_eHandle;
    NSFileHandle    *_termHandle;
    IBOutlet NSTextField     *_tfCommand4Terminal;
    IBOutlet JKMessageViewController    *_termDisplayer;
}

@end

@implementation DebugWindow

static NSArray *colorSet;
static dispatch_once_t token;
-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
        dispatch_once(&token, ^(){
            colorSet = @[[NSColor blackColor], [NSColor orangeColor], [NSColor redColor]];
        });
        
        NSError *err = nil;
        _devIndexRegex = [[NSRegularExpression alloc] initWithPattern:@"#([0-9]+)$" options:0 error:&err];
        
        _loadFlag = NO;
        
//        [self initTerminal];
    }
    
    return self;
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        if(_loadFlag == NO)
        {
            NSMutableArray *idSet = [[NSMutableArray alloc] init];
            //加载
            JKTestScript *script = [JKTestScript scriptWithName:[AppConfig config].testPlanName];
            NSArray *items = script.itemSet;
            [self collectItemIDInSet:items toSet:idSet];
            
            [_cbItemIDList removeAllItems];
            [_cbItemIDList addItemWithObjectValue:@"N/A"];
            [_cbItemIDList addItemsWithObjectValues:idSet];
            
            if(_currentItemName
               && [_cbItemIDList.objectValues containsObject:_currentItemName])
            {
                [_cbItemIDList selectItemWithObjectValue:_currentItemName];
            }
            else
            {
                [_cbItemIDList selectItemAtIndex:0];
            }
            
            _loadFlag = YES;
        }
    });
}


-(void)collectItemIDInSet:(NSArray *)itemSet toSet:(NSMutableArray *)idSet
{
    for(JKTestItem *item in itemSet)
    {
        [idSet addObject:[NSString stringWithFormat:@"%@:%@", item.itemID, item.itemName]];
        [self collectItemIDInSet:item.subItems toSet:idSet];
    }
}

-(void)loadDevices
{
    if(_currentItem)
    {
        NSMutableArray *devSet = [[NSMutableArray alloc] init];
        for(JKOperation *op in _currentItem.operations)
        {
            NSMutableString *devName = [op.device mutableCopy];
            if([devName containsString:@"#<@>"])
            {
                NSString *devPrefix = [devName substringToIndex:devName.length-4];
                NSArray *devices = [[JKDeviceManager sharedManager] devicesWithNamePrefix:devPrefix];
                NSMutableArray *nameArr = [[NSMutableArray alloc] init];
                for(JKBaseDevice *dev in devices)
                {
                    if([devSet containsObject:dev.configName] == NO)
                    {
                        [nameArr addObject:dev.configName];
                    }
                }
                [devSet addObjectsFromArray:[nameArr sortedArrayUsingComparator:[JKUtility stringComparator]]];
            }
            else if([devSet containsObject:devName] == NO)
            {
                [devSet addObject:devName];
            }
        }
        
        [_cbDevList removeAllItems];
        [_cbDevList addItemsWithObjectValues:devSet];
    }
    else
    {
        NSArray *devNames = [JKDeviceManager sharedManager].deviceDictionary.allKeys;
        devNames = [devNames sortedArrayUsingComparator:[JKUtility stringComparator]];
        
        [_cbDevList removeAllItems];
        for(NSString *devName in devNames)
        {
            if([self commandSetForDevice:devName].count > 0)
            {
                [_cbDevList addItemWithObjectValue:devName];
            }
        }
    }
    
    if(_cbDevList.numberOfItems > 0)
    {
        if(_currentDevName
           && [_cbDevList.objectValues containsObject:_currentDevName])
        {
            [_cbDevList selectItemWithObjectValue:_currentDevName];
        }
        else
        {
            [_cbDevList selectItemAtIndex:0];
        }
    }
}

- (void)loadCommandsForDevice:(NSString *)devName
{
    NSArray *cmdSet = [self commandSetForDevice:devName];
    
    _cbCommandList.stringValue = @"";
    [_cbCommandList removeAllItems];
    [_cbCommandList addItemsWithObjectValues:cmdSet];
    _btSendCommand.enabled = cmdSet.count > 0;
}

-(NSArray *)commandSetForDevice:(NSString *)devName
{
    NSMutableArray  *cmdSet = [[NSMutableArray alloc] init];
    
    if(_currentItem)
    {
        NSMutableString *patternName = [devName mutableCopy];
        NSTextCheckingResult *rst = [_devIndexRegex firstMatchInString:patternName options:0 range:NSMakeRange(0, patternName.length)];
        _dutIndex = nil;
        if(rst && rst.range.location != NSNotFound)
        {
            _dutIndex = [NSNumber numberWithInt:[[devName substringWithRange:[rst rangeAtIndex:1]] intValue]];
            [patternName replaceCharactersInRange:rst.range withString:@"#<@>"];
        }
        
        [self collectCommandInItem:_currentItem forDevice:patternName toSet:cmdSet];
    }
    else
    {
        //// 从配置加载
        JKBaseDevice *dev = [[JKDeviceManager sharedManager] deviceWithName:devName];
        NSDictionary *cmdDic = [dev.devConfig valueForKeyPath:@"Commands"];
        [self collectCommandInConfig:cmdDic toSet:cmdSet];
        
        //// 从脚本加载
        //处理Device名称
        NSMutableString *patternName = [devName mutableCopy];
        NSTextCheckingResult *rst = [_devIndexRegex firstMatchInString:patternName options:0 range:NSMakeRange(0, patternName.length)];
        _dutIndex = nil;
        if(rst && rst.range.location != NSNotFound)
        {
            _dutIndex = [NSNumber numberWithInt:[[devName substringWithRange:[rst rangeAtIndex:1]] intValue]];
            [patternName replaceCharactersInRange:rst.range withString:@"#<@>"];
        }
        //加载
        JKTestScript *script = [JKTestScript scriptWithName:[AppConfig config].testPlanName];
        NSArray *items = script.itemSet;
        for(JKTestItem *item in items)
        {
            [self collectCommandInItem:item forDevice:patternName toSet:cmdSet];
        }
    }
    
    return cmdSet;
}

- (void)collectCommandInItem:(JKTestItem *)item forDevice:(NSString *)devName toSet:(NSMutableArray *)cmdSet
{
//    NSDictionary *pDic = @{JKPDKEY_DUTINDEX:_dutIndex};
    NSMutableDictionary *pDic = [NSMutableDictionary dictionary];

    NSString *realCmd = nil;
    for(JKOperation *op in item.operations)
    {
        if([op.device isEqualTo:devName] && op.commAction.command)
        {
            if(_dutIndex)
            {
                [pDic setValue:_dutIndex forKey:JKPDKEY_DUTINDEX];
                realCmd = [op.commAction realCommandWithParam:pDic];
                if(realCmd && [realCmd isNotEqualTo:@""]
                   && [cmdSet containsObject:realCmd] == NO)
                {
                    [cmdSet addObject:realCmd];
                }
            }
            else
            {
                for(int i=1; i<=[AppConfig config].dutCount; i++)
                {
                    NSNumber *idx = [NSNumber numberWithInteger:i];
                    [pDic setValue:idx forKey:JKPDKEY_DUTINDEX];
                    realCmd = [op.commAction realCommandWithParam:pDic];
                    if(realCmd && [realCmd isNotEqualTo:@""]
                       && [cmdSet containsObject:realCmd] == NO)
                    {
                        [cmdSet addObject:realCmd];
                    }
                }
            }
        }
    }
    
    for(JKTestItem *subItem in item.subItems)
    {
        [self collectCommandInItem:subItem forDevice:devName toSet:cmdSet];
    }
}


- (BOOL)findOperationInItem:(JKTestItem *)item
{
    NSMutableArray *dutIdxSet = [NSMutableArray array];
    if(_dutIndex)
    {
        [dutIdxSet addObject:_dutIndex];
    }
    else
    {
        for(int i=1; i<=[AppConfig config].dutCount; i++)
        {
            [dutIdxSet addObject:[NSNumber numberWithInteger:i]];
        }
    }
    NSMutableDictionary *pDic = [NSMutableDictionary dictionary];
    
    for(NSNumber *dutIndex in dutIdxSet)
    {
        [pDic setValue:dutIndex forKey:JKPDKEY_DUTINDEX];
    
        NSMutableString *dName = [_cbDevList.stringValue mutableCopy];
        NSTextCheckingResult *rst = [_devIndexRegex firstMatchInString:dName options:0 range:NSMakeRange(0, dName.length)];
        if(rst && rst.range.location != NSNotFound)
        {
            [dName replaceCharactersInRange:rst.range withString:@"#<@>"];
        }
        for(JKOperation *op in item.operations)
        {
            if(op.commAction.command)
            {
                if([op.device isEqualTo:dName])
                {
    //                _currentOperation = op;
                    if([[op.commAction realCommandWithParam:pDic] isEqualTo:_cbCommandList.stringValue])
                    {
                        _dutIndex = dutIndex;
                        _currentOperation = op;
                        return YES;
                    }
                }
            }
        }
        
        for(JKTestItem *subItem in item.subItems)
        {
            if([self findOperationInItem:subItem])
            {
                return YES;
            }
        }
    }
    
    return NO;
}


-(void)showMessage:(JKLogMessage *)logMessage
{
    [_appDisplayer showLogMessage:logMessage];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)sendCommand:(id)sender
{
    if([_cbDevList.stringValue isNotEqualTo:@""])
    {
        _btSendCommand.enabled = NO;
        [[[NSThread alloc] initWithTarget:self selector:@selector(sendCommand) object:nil] start];
    }
}

-(void)sendCommand
{
    _currentOperation = nil;
//    JKTestScript *script = [JKTestScript scriptWithName:[AppConfig config].scriptName];
    JKTestScript *script = [JKTestScript scriptWithName:[AppConfig config].testPlanName];
    NSArray *items = script.itemSet;
    for(JKTestItem *item in items)
    {
        if([self findOperationInItem:item])
        {
            break;
        }
    }
    
    NSString *retValue = nil;
    
    NSString *dName = _cbDevList.stringValue;
    [_currentOperation setValue:_cbCommandList.stringValue forKeyPath:@"commAction.command"];
    if(_currentOperation)
    {
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        NSTextCheckingResult *rst = [_devIndexRegex firstMatchInString:dName options:0 range:NSMakeRange(0, dName.length)];
        if(rst && rst.range.location != NSNotFound)
        {
            [paramDic setValue:_dutIndex forKey:JKPDKEY_DUTINDEX];
        }
        [paramDic setValue:_dutIndex forKey:JKPDKEY_DUTINDEX];
        [paramDic setValue:self forKey:JKPDKEY_DBOBSERVER];
        [_currentOperation runWithParamDic:paramDic];
        retValue = _currentOperation.orgValue;
    }
    else
    {
        NSString *cmd = _cbCommandList.stringValue;
        cmd = [cmd stringByRestoreInvisibleCharacter];
        JKBaseDevice *device = (JKBaseDevice *)[[JKDeviceManager sharedManager] deviceWithName:dName];
        NSDictionary *cmdDic = [device.devConfig valueForKeyPath:@"Commands"];
        
        NSDictionary *config = [self configContainsCommand:cmd inConfigSet:cmdDic];
        double timeout = 5;
        NSString *endMark = @"\r\n";
        if(config)
        {
            timeout = [[config valueForKeyPath:@"Timeout"] doubleValue];
            timeout = timeout <= 0 ? 5 : timeout;
            
            endMark = [config valueForKeyPath:@"EndMark"];
        }
        else
        {
            NSString *tmp = [cmd uppercaseString];
            NSTextCheckingResult *rst = [customCmdRegex firstMatchInString:tmp options:0 range:NSMakeRange(0, tmp.length)];
            if(rst && rst.range.location != NSNotFound)
            {
                timeout = [[cmd substringWithRange:[rst rangeAtIndex:2]] doubleValue];
                endMark = [cmd substringWithRange:[rst rangeAtIndex:3]];
                cmd = [cmd substringToIndex:[rst rangeAtIndex:1].location];
            }
        }
        
        NSMutableString *mValue = [[NSMutableString alloc] init];

        retValue = [device readFeedBackWithParamDic:nil];
        if(retValue && [retValue isNotEqualTo:@""])
        {
            [self showMessage:[JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@]<< %@", device.configName, retValue]]];
        }
        [self showMessage:[JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@]>> %@", device.configName, cmd]]];
        [device sendCommand:cmd withParamDic:nil];
        JKTimer *timer = [JKTimer timer];
        [timer start];
        do
        {
            retValue = [device readFeedBackWithParamDic:nil];
            if(retValue && [retValue isNotEqualTo:@""])
            {
                [self showMessage:[JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@]<< %@", device.configName, retValue]]];
                [mValue appendString:retValue];
            }
            if([mValue containsString:endMark])
            {
                break;
            }
            [NSThread sleepForTimeInterval:0.01];
        }while(timer.durationInSecond < timeout);
        retValue = [mValue copy];
    }
    
    if(retValue == nil)
    {
        [self showMessage:[JKLogMessage msgWithInfo:[NSString stringWithFormat:@"Read timeout Or Return Value is nil"] withLevel:MSG_WARNING]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        _btSendCommand.enabled = YES;
    });
}

- (void)collectCommandInConfig:(id)config toSet:(NSMutableArray *)cmdSet
{
    if([config isKindOfClass:NSDictionary.class])
    {
        NSDictionary *tmpConfig = (NSDictionary *)config;
        if([tmpConfig.allKeys containsObject:@"Command"])
        {
            [cmdSet addObject:[tmpConfig valueForKeyPath:@"Command"]];
        }
        else
        {
            for(id cfg in tmpConfig.allValues)
            {
                [self collectCommandInConfig:cfg toSet:cmdSet];
            }
        }
    }
    else if([config isKindOfClass:NSArray.class])
    {
        NSArray *tmpArray = (NSArray *)config;
        for(id value in tmpArray)
        {
            [self collectCommandInConfig:value toSet:cmdSet];
        }
    }
}

- (NSDictionary *)configContainsCommand:(NSString *)cmd inConfigSet:(id)cfgSet;
{
    if([cfgSet isKindOfClass:NSDictionary.class])
    {
        if([cfgSet valueForKeyPath:@"Command"]
           && [[cfgSet valueForKeyPath:@"Command"] isEqualTo:cmd])
        {
            return cfgSet;
        }
        else
        {
            for(id value in ((NSDictionary *)cfgSet).allValues)
            {
                id cfg = [self configContainsCommand:cmd inConfigSet:value];
                if(cfg)
                {
                    return cfg;
                }
            }
        }
    }
    else if([cfgSet isKindOfClass:NSArray.class])
    {
        NSArray *tmpArray = (NSArray *)cfgSet;
        for(id value in tmpArray)
        {
            id cfg = [self configContainsCommand:cmd inConfigSet:value];
            if(cfg)
            {
                return cfg;
            }
        }
    }
    
    return nil;
}

- (IBAction)close:(id)sender
{
    _loadFlag = NO;
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    [self.window close];
//    [self.window show]
}

-(void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    NSComboBox *cb = notification.object;
    if(cb)
    {
        if([cb.identifier isEqualTo:@"ItemID"])
        {
            JKTestScript *script = [JKTestScript scriptWithName:[AppConfig config].testPlanName];
            NSString *itemIDAndName = _cbItemIDList.objectValueOfSelectedItem;
            NSRange rangeOfColon    = [itemIDAndName rangeOfString:@":"];
            NSInteger   location = rangeOfColon.location != NSNotFound ? rangeOfColon.location : itemIDAndName.length;
            NSString *itemID = [itemIDAndName substringToIndex:location];
            _currentItem = [self itemWithID:itemID inSet:script.itemSet];
            
            if(_loadFlag)
            {
                _currentItemName = itemIDAndName;
            }
            
            [self loadDevices];
        }
        else if([cb.identifier isEqualTo:@"Device"])
        {
            if(cb.objectValueOfSelectedItem)
            {
                if(_loadFlag)
                {
                    _currentDevName = cb.objectValueOfSelectedItem;
                }
                _currentDevice = [[JKDeviceManager sharedManager] deviceWithName:_currentDevName];
                
                [self loadCommandsForDevice:cb.objectValueOfSelectedItem];
                if(_cbCommandList.numberOfItems > 0)
                {
                    if(_currentCommand
                       && [_cbCommandList.objectValues containsObject:_currentCommand])
                    {
                        [_cbCommandList selectItemWithObjectValue:_currentCommand];
                    }
                    else
                    {
                        [_cbCommandList selectItemAtIndex:0];
                    }
                }
            }
        }
        else if([cb.identifier isEqualTo:@"Command"])
        {
            if(_loadFlag)
            {
                _currentCommand = cb.objectValueOfSelectedItem;
            }
        }
    }
}

-(JKTestItem *)itemWithID:(NSString *)itemID inSet:(NSArray *)itemSet
{
    JKTestItem *tItem = nil;
    
    for(JKTestItem *item in itemSet)
    {
        if([item.itemID isEqualTo:itemID])
        {
            tItem = item;
        }
        else
        {
            tItem = [self itemWithID:itemID inSet:item.subItems];
        }
        
        
        if(tItem)
        {
            break;
        }
    }
    
    return tItem;
}

-(void)comboBoxWillPopUp:(NSNotification *)notification
{
    NSComboBox *cb = notification.object;
    if(cb)
    {
        if([cb.identifier isEqualTo:@"Command"])
        {
            NSInteger idx = _currentCommand ? [cb indexOfItemWithObjectValue:_currentCommand] : 0;
            [cb scrollItemAtIndexToVisible:idx];
        }
    }
}

static dispatch_once_t customCmdToken;
static NSRegularExpression *customCmdRegex;
-(void)controlTextDidChange:(NSNotification *)obj
{
    dispatch_once(&customCmdToken, ^(){
        NSError *err = nil;
        NSRegularExpressionOptions option = NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionAnchorsMatchLines;
        customCmdRegex = [NSRegularExpression regularExpressionWithPattern:@".*(<TIMEOUT *: *([0-9.]+) *, *ENDMARK *: *([^ ].*)>)$" options:option error:&err];
        NSLog(@"customCmdRegex: %@", err);
    });
    NSComboBox *cb = (NSComboBox *)obj.object;
    if(cb)
    {
        if([cb.identifier isEqualTo:@"Command"])
        {
            if([cb.stringValue isEqualTo:@""])
            {
                _btSendCommand.enabled = NO;
            }
            else
            {
                if([cb.objectValues containsObject:cb.stringValue])
                {
                    _btSendCommand.enabled = YES;
                }
                else
                {
                    NSTextCheckingResult *rst = [customCmdRegex firstMatchInString:[cb.stringValue uppercaseString] options:0 range:NSMakeRange(0, cb.stringValue.length)];
                    if(rst && rst.range.location != NSNotFound)
                    {
                        _btSendCommand.enabled = YES;
                    }
                    else
                    {
                        _btSendCommand.enabled = NO;
                    }
                }
            }
        }
    }
}

@end
