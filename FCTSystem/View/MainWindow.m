//
//  MainWindow.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "MainWindow.h"
#import "ConfigWindow.h"
#import "DebugWindow.h"
#import "LogWindow.h"
#import "AuthorizationWindow.h"
#import "AppConfig.h"
#import "MainBoard.h"
#import "Fixture.h"

@import JKFramework;


//#import "FixtureDevice.h"
//#import "DUTDevice.h"

#define PROMPT_SCAN_SN_FORMAT       @"Scan SerialNumber\nSite %d"

@implementation MainWindow
{
    IBOutlet NSWindow           *_window;
    
    ConfigWindow                *_cfgWindow;
    LogWindow                   *_logWindow;
    AuthorizationWindow         *_authWindow;
    DebugWindow                 *_debugWindow;
    
    IBOutlet DUTContainer        *_dutContainer;
    IBOutlet NSTextField        *_tfAppName;
    
    IBOutlet NSTextField        *_tfSerialNumberEntry;
    IBOutlet NSTextField        *_lbPrompt;
    
    IBOutlet NSTextField        *_tfTestCount;
    IBOutlet NSTextField        *_tfPassCount;
    IBOutlet NSTextField        *_tfYield;
    
    IBOutlet NSTextField        *_tfTotalTestTime;
    IBOutlet NSTextField        *_tfTotalTestTime4Group1;
    IBOutlet NSTextField        *_tfTotalTestTime4Group2;
    
    IBOutlet NSImageView        *_ivLed4DMM1;
    IBOutlet NSImageView        *_ivLed4DMM2;
    IBOutlet NSImageView        *_ivLed4DMM3;
    IBOutlet NSImageView        *_ivLed4DMM4;
    NSDictionary<NSString *, __kindof NSImageView *> *_dmmLedDic;
    IBOutlet NSImageView        *_ivLed4DUT1;
    IBOutlet NSImageView        *_ivLed4DUT2;
    IBOutlet NSImageView        *_ivLed4DUT3;
    IBOutlet NSImageView        *_ivLed4DUT4;
    NSDictionary<NSString *, __kindof NSImageView *> *_dutLedDic;
    IBOutlet NSImageView        *_ivLed4ELoad1;
    IBOutlet NSImageView        *_ivLed4ELoad2;
    NSDictionary<NSString *, __kindof NSImageView *> *_eLoadLedDic;
    IBOutlet NSImageView        *_ivLed4RB1;
    IBOutlet NSImageView        *_ivLed4RB2;
    IBOutlet NSImageView        *_ivLed4RB3;
    IBOutlet NSImageView        *_ivLed4RB4;
    NSDictionary<NSString *, __kindof NSImageView *> *_rbLedDic;
    IBOutlet NSImageView        *_ivMotioinController;
    IBOutlet NSImageView        *_ivWinPC;
    BOOL        _fixtureFlag;
    BOOL        _dutFlag;
    BOOL        _reservedFlag;
    
    IBOutlet NSBox          *_boxDeviceStates;
    
    IBOutlet NSMenu         *_runModeMenu;
    
    NSRegularExpression         *_snRegex;
    
    NSMutableDictionary         *_snDic;
    
    NSArray<NSNumber *>     *_enabledSites;
    
    NSLock      *_checkLock;
    
    BOOL        _dbStartPressed;
    
    IBOutlet NSButton       *_btStart;
    IBOutlet NSButton       *_btAbort;
    BOOL                    _abortTest;
    BOOL                _systemAvailable;
    BOOL                _manualTestFlag;
    NSMutableDictionary *_testFlagSet;
    NSLock              *_synchLock;
}

-(void)awakeFromNib
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString.mutableString appendString:[NSString stringWithFormat:@"%@", [NSProcessInfo processInfo].processName]];
//    _tfAppName.stringValue = [NSString stringWithFormat:@"%@", [NSProcessInfo processInfo].processName];
    _tfAppName.stringValue = [NSString stringWithFormat:@"%@", [AppConfig config].appName];
    
    NSError *err = nil;
    _snRegex = [[NSRegularExpression alloc] initWithPattern:@"^[0-9A-Za-z]*$" options:0 error:&err];
    
    _snDic = [[NSMutableDictionary alloc] init];
    _testFlagSet = [NSMutableDictionary dictionary];
    for(int gIdx=1; gIdx<=[AppConfig config].ChannelGroup.count; gIdx++)
    {
        [_testFlagSet setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:gIdx]];
    }
    
    _dmmLedDic = @{_ivLed4DMM1.identifier:_ivLed4DMM1,
                   _ivLed4DMM2.identifier:_ivLed4DMM2,
                   _ivLed4DMM3.identifier:_ivLed4DMM3,
                   _ivLed4DMM4.identifier:_ivLed4DMM4};

    
    _dutLedDic = @{_ivLed4DUT1.identifier:_ivLed4DUT1,
                   _ivLed4DUT2.identifier:_ivLed4DUT2,
                   _ivLed4DUT3.identifier:_ivLed4DUT3,
                   _ivLed4DUT4.identifier:_ivLed4DUT4};
    
    _cfgWindow      = [[ConfigWindow alloc] init];
    _logWindow      = [[LogWindow alloc] init];
    _authWindow     = [[AuthorizationWindow alloc] init];
    _debugWindow    = [[DebugWindow alloc] init];
    
    [_dutContainer addObserver:self forKeyPath:@"testedDUTCount" options:NSKeyValueObservingOptionNew context:nil];
    [_dutContainer addObserver:self forKeyPath:@"enabledChangeFlag" options:NSKeyValueObservingOptionNew context:nil];
    [_dutContainer addObserver:self forKeyPath:@"loopTimes" options:NSKeyValueObservingOptionNew context:nil];
    
    _btStart.hidden = ![AppConfig config].startTestByButton;
    
    _fixtureFlag     = NO;
    _dutFlag         = NO;
    _reservedFlag    = NO;
    
    _dbStartPressed    = NO;
    
    _checkLock = [[NSLock alloc] init];
    _synchLock = [[NSLock alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manualTestStart:) name:kManualTestStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manualTestFinish:) name:kManualTestFinishNotification object:nil];
}

- (void)loadDeviceStateView
{
    NSString *tmpCategoryName;
    NSMutableArray *devCategoryNames = [NSMutableArray array];
    NSDictionary *devDic = [JKDeviceManager sharedManager].deviceDictionary;
//    NSDictionary *devConfigDic = [JKDeviceManager sharedManager].configDictionary;
    for(NSString *devName in devDic.allKeys)
    {
        tmpCategoryName = devName;
        if([tmpCategoryName containsString:@"#"])
        {
            tmpCategoryName = [devName substringToIndex:[tmpCategoryName rangeOfString:@"#"].location];
        }
        
        if([devCategoryNames containsObject:tmpCategoryName] == NO
           && [[AppConfig config] needCheckStateForDeviceCategory:tmpCategoryName])
        {
            [devCategoryNames addObject:tmpCategoryName];
        }
    }
    
//    for(NSString *devCategory in devCategoryNames)
//    {
//        
//    }
}

- (void)refresh:(RefreshType)type
{
    _btStart.hidden = ![AppConfig config].startTestByButton;
    
    if((type&RunModeChanged) == RunModeChanged)
    {
        [self refreshRunMode];
    }
    
    if((type&ScriptChanged) == ScriptChanged)
    {
        [_dutContainer resizeView];
    }
    
    if((type&ConfigChanged) == ConfigChanged)
    {
        [_dutContainer resizeView];
        [[JKDeviceManager sharedManager] resetAllDevices];
    }
}

- (void)refreshRunMode
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [_runModeMenu removeAllItems];
        NSArray *supportedRunModes = [AppConfig config].supportedRunModes;
        for(NSString *mode in supportedRunModes)
        {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:mode action:@selector(runModeChanged:) keyEquivalent:@""];
            item.state = [mode isEqualTo:[AppConfig config].currentRunMode] ? 1 : 0;
            [_runModeMenu addItem:item];
            
        }
    });
}

- (void)runModeChanged:(NSMenuItem *)sender
{
    [AppConfig config].currentRunMode = sender.title;
    [self refresh:RunModeChanged|ScriptChanged];
}

-(void)appDidLaunching
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        NSRect fullFrame = [NSScreen mainScreen].visibleFrame;
        [_window setFrame:fullFrame display:YES];
        [self refreshRunMode];
//        [_dutContainer selectDUTAtSite:0];
    });
}

-(void)checkSystemState
{
    [_tfSerialNumberEntry selectText:self];
    
    _enabledSites = _dutContainer.enabledSites;
    
    NSLog(@"Start to check system state\n%@", [NSThread currentThread]);

    NSMutableDictionary *dmmAvailableDic = [@{@"1":[NSNumber numberWithBool:NO],
                                              @"2":[NSNumber numberWithBool:NO],
                                              @"3":[NSNumber numberWithBool:NO],
                                              @"4":[NSNumber numberWithBool:NO]} mutableCopy];
    NSMutableDictionary *dutAvailableDic = [@{@"1":[NSNumber numberWithBool:NO],
                                               @"2":[NSNumber numberWithBool:NO],
                                               @"3":[NSNumber numberWithBool:NO],
                                               @"4":[NSNumber numberWithBool:NO]} mutableCopy];

    NSArray __block *devArray = nil;
    while([NSThread mainThread].isExecuting)
    {
//        [[AppConfig config].globalLock lock];
        dispatch_sync(dispatch_get_main_queue(), ^(){
            
            NSString *devPrefix = @"MainBoard";
            devArray = [[JKDeviceManager sharedManager] devicesWithNamePrefix:devPrefix];
            for(JKBaseDevice *dev in devArray)
            {
                NSNumber *devIndex = @([[dev.configName substringFromIndex:devPrefix.length+1] integerValue]-1);
                if([_enabledSites containsObject:devIndex])
                {
                    [_dmmLedDic objectForKey:dev.configName].image    = dev.exist ? [AppConfig config].imgGreenLed : [AppConfig config].imgRedLed;
                    
                    [dmmAvailableDic setObject:[NSNumber numberWithBool:dev.exist] forKey:[dev.configName substringFromIndex:4]];
                }
                else
                {
                    [_dmmLedDic objectForKey:dev.configName].image = [AppConfig config].imgGrayLed;
                }
            }
            
            devPrefix = @"DUT";
            devArray = [[JKDeviceManager sharedManager] devicesWithNamePrefix:devPrefix];
            for(JKBaseDevice *dev in devArray)
            {
                NSNumber *devIndex = @([[dev.configName substringFromIndex:devPrefix.length+1] integerValue]-1);
                if([_enabledSites containsObject:devIndex])
                {
                    NSImageView *iv = [_dutLedDic objectForKey:dev.configName];
                    if([iv.image isEqual:[AppConfig config].imgGreenLed] && dev.exist == NO)
                    {
                        //                    [dev close];
                        [_logWindow showLog:[JKLogMessage msgWithInfo:[NSString stringWithFormat:@"%@ disconnected!", dev.configName]]];
                    }
                    else if([iv.image isEqual:[AppConfig config].imgRedLed] && dev.exist == YES)
                    {
                        [_logWindow showLog:[JKLogMessage msgWithInfo:[NSString stringWithFormat:@"%@ connected.", dev.configName]]];
                    }
                    
                    [_dutLedDic objectForKey:dev.configName].image    = dev.exist ? [AppConfig config].imgGreenLed : [AppConfig config].imgRedLed;

                    [dutAvailableDic setObject:[NSNumber numberWithBool:dev.exist] forKey:[dev.configName substringFromIndex:devPrefix.length+1]];
                }
                else
                {
                    [_dutLedDic objectForKey:dev.configName].image = [AppConfig config].imgGrayLed;
                }
            }
            

            
            JKBaseDevice *motionDevice = [[JKDeviceManager sharedManager] deviceWithName:@"Fixture"];
            _ivMotioinController.image  = motionDevice.exist ? [AppConfig config].imgGreenLed : [AppConfig config].imgRedLed;
            JKBaseDevice *winPC = (JKBaseDevice *)[[JKDeviceManager sharedManager] devicesWithNamePrefix:@"WinPC"][0];
            _ivWinPC.image = winPC.exist ? [AppConfig config].imgGreenLed : [AppConfig config].imgRedLed;
            
            BOOL isAvailable = motionDevice.exist && winPC.exist;
            if(isAvailable)
            {
                for(NSString *key in dmmAvailableDic.allKeys)
                {
                    isAvailable = isAvailable && ([[dmmAvailableDic objectForKey:key] boolValue]); //取决于同一模块的mainboard
                }
            }
            
            if(!isAvailable)
            {
                [self setPrompt:@"Fixture not ready" level:0];
            }
            
            BOOL groupTestFlag = YES;
            for(NSNumber *gIdx in _testFlagSet.allKeys)
            {
                groupTestFlag &= [[_testFlagSet objectForKey:gIdx] boolValue];
            }
            
            BOOL snEntryFlag = _tfSerialNumberEntry.enabled;
            _tfSerialNumberEntry.enabled = (isAvailable || [AppConfig config].debugEnabled) && _enabledSites.count > 0;
            if(snEntryFlag == NO && _tfSerialNumberEntry.enabled)
            {
                [_tfSerialNumberEntry selectText:self];
            }
            
            if(_enabledSites.count == 0)
            {
                [self setPrompt:@"No site enabled" level:0];
            }
            
            _systemAvailable = isAvailable;
        });
        
//        [[AppConfig config].globalLock unlock];
        [NSThread sleepForTimeInterval:1];
    }
    
    NSLog(@"End check system state\n%@", [NSThread currentThread]);
}

- (void)setPrompt:(NSString *)prompt level:(NSInteger)level
{
    _lbPrompt.stringValue = prompt;
    switch (level) {
        case 1:
            _lbPrompt.textColor = [NSColor redColor];
            break;
        default:
            _lbPrompt.textColor = [NSColor blueColor];
            break;
    }
}

static NSInteger testedDUTCount = 0;        //单次测试的已测试dut统计
static NSInteger testedDUTCount4Group1 = 0;
static NSInteger testedDUTCount4Group2 = 0;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualTo:@"testedDUTCount"])
    {
        dispatch_sync(dispatch_get_main_queue(), ^(){
            _tfTestCount.stringValue    = [NSString stringWithFormat:@"%d", _dutContainer.testedDUTCount];
            _tfPassCount.stringValue    = [NSString stringWithFormat:@"%d", _dutContainer.passDUTCount];
            _tfYield.stringValue        = [NSString stringWithFormat:@"%.1lf%%", _dutContainer.passDUTCount * 100.0 / _dutContainer.testedDUTCount];
        });
        testedDUTCount++;
        
    }
    else if([keyPath isEqualTo:@"loopTimes"])
    {
        NSInteger loopTimes = [[change objectForKey:@"new"] integerValue];
        if(loopTimes == [AppConfig config].loopTestTimes || _abortTest)
        {
            for(int gIdx = 1; gIdx <= [AppConfig config].ChannelGroup.count; gIdx++)
            {
                [_testFlagSet setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:gIdx]];
            }
            dispatch_sync(dispatch_get_main_queue(), ^(){
                _lbPrompt.stringValue = [NSString stringWithFormat:PROMPT_SCAN_SN_FORMAT, _dutContainer.enabledSites.firstObject.intValue+1];
                [_dutContainer enableControl];
                _btAbort.enabled    = NO;
                _tfSerialNumberEntry.enabled = _systemAvailable || [AppConfig config].debugEnabled;
                [_tfSerialNumberEntry selectText:self];
                
                _btStart.enabled = NO;
            });
            Fixture *mDevice = (Fixture *)[[JKDeviceManager sharedManager] deviceWithName:@"Fixture"];
            
            if([AppConfig config].debugEnabled == NO)
            {
                [mDevice runEndCommands];
            }
        }
        else
        {
            _lbPrompt.stringValue = [NSString stringWithFormat:@"Testing...%@"
                                     , [AppConfig config].loopTestEnabled && _manualTestFlag==NO ? [NSString stringWithFormat:@"\r\n(LoopTest: %ld/%ld)", loopTimes+1, [AppConfig config].loopTestTimes] : @""];
        }
    }
    else if([keyPath isEqualTo:@"enabledChangeFlag"])
    {
        dispatch_async(dispatch_get_main_queue(), ^(){
            snCount = 0;
            [_snDic removeAllObjects];
            if(_dutContainer.enabledSites.count > 0)
            {
                _lbPrompt.stringValue = [NSString stringWithFormat:PROMPT_SCAN_SN_FORMAT, _dutContainer.enabledSites.firstObject.intValue+1];
                _tfSerialNumberEntry.enabled = _systemAvailable;
                [_tfSerialNumberEntry selectText:self];
            }
            _enabledSites = _dutContainer.enabledSites;
        });
    }
    else if([keyPath isEqualTo:@"logMessage"])
    {
        JKLogMessage *lm = [change objectForKey:@"new"];
        [_logWindow showLog:lm];
    }
}

- (void)manualTestStart:(NSNotification *)notification
{
    _manualTestFlag = YES;
    DUTView *dv = (DUTView *)notification.object;
    NSNumber *dutIdx = [NSNumber numberWithInteger:dv.site];
    int gIdx = 1;
    for(NSArray *dutIdxSet in [AppConfig config].ChannelGroup)
    {
        if([dutIdxSet containsObject:dutIdx])
        {
            [_testFlagSet setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:gIdx]];
            break;
        }
        gIdx++;
    }
    _btAbort.enabled = YES;
}

- (void)manualTestFinish:(NSNotification *)notification
{
    _manualTestFlag = NO;
    
    DUTView *dv = (DUTView *)notification.object;
    NSNumber *dutIdx = [NSNumber numberWithInteger:dv.site];
    int gIdx = 1;
    for(NSArray *dutIdxSet in [AppConfig config].ChannelGroup)
    {
        if([dutIdxSet containsObject:dutIdx])
        {
            [_testFlagSet setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:gIdx]];
            break;
        }
        gIdx++;
    }
    
    _btAbort.enabled = NO;
}

static NSInteger snCount = 0;
-(void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *snTextField = (NSTextField *)(obj.object);
    if([[snTextField identifier] isEqualTo:@"SN_Entry"])
    {
        NSTextField *tfSN = (NSTextField *)obj.object;
        NSMutableString *tmpSN = [[tfSN.stringValue uppercaseString] mutableCopy];
        NSTextCheckingResult *rst = [_snRegex firstMatchInString:tmpSN options:0 range:NSMakeRange(0, tmpSN.length)];
        if(rst==nil || rst.range.location == NSNotFound)
        {
            NSRange selRange = tfSN.currentEditor.selectedRange;
            [tmpSN deleteCharactersInRange:NSMakeRange(selRange.location-1, 1)];
        }
        tfSN.stringValue = [tmpSN copy];
        
        if(tmpSN.length >= [AppConfig config].snLength)
        {
            [_snDic setObject:tmpSN forKey:_dutContainer.enabledSites[snCount]];
            [_dutContainer setSerialNumber:tmpSN forSite:_dutContainer.enabledSites[snCount].integerValue];
            
            
            if(++snCount >= _dutContainer.enabledSites.count)
            {
                snTextField.stringValue = @"";
                snTextField.enabled = NO;
                [_dutContainer disableControl];
                testedDUTCount = 0;
                testedDUTCount4Group1 = 0;
                testedDUTCount4Group2 = 0;
                
                if([AppConfig config].startTestByButton)
                {
                    _lbPrompt.stringValue = @"SN Ready";
                    _btStart.enabled = YES;
                }
                else
                {
                    _lbPrompt.stringValue = @"SN Ready";
                    
                    snCount = 0;
                    [[[NSThread alloc] initWithTarget:self selector:@selector(startTest:) object:nil] start];
                }
            }
            else
            {
                _lbPrompt.stringValue = [NSString stringWithFormat:PROMPT_SCAN_SN_FORMAT, _dutContainer.enabledSites[snCount].intValue+1];
                snTextField.stringValue = @"";
                [snTextField selectText:self];
            }
        }
    }
}

//-(void)checkMotionState
//{
//    Fixture *mDevice = (Fixture *)[[JKDeviceManager sharedManager] deviceWithName:@"Fixture"];
//    _abortTest = NO;
//    _btAbort.enabled = YES;
//    if(mDevice)
//    {
//        _lbPrompt.stringValue = @"Checking carrier state...";
//        [JKLog writeMessage:@"Checking carrier state..." toFile:mDevice.logFilePath];
//
//        for(NSInteger gIdx=1; gIdx<=[AppConfig config].ChannelGroup.count; gIdx++)
//        {
//            [[[NSThread alloc] initWithTarget:self selector:@selector(checkForDUTGroup:) object:[NSNumber numberWithInteger:gIdx]] start];
//        }
//    }
//}

//- (void)checkForDUTGroup:(NSNumber *)groupIndex
//{
//    NSLog(@"Checking for dut-group %@...", groupIndex);
//    NSArray *globaldutIndexSet = _dutContainer.enabledSites;
//    NSArray *dutIndexSet = [AppConfig config].ChannelGroup[groupIndex.integerValue-1];
//    
//    NSMutableArray *enabledDUTIndexSetOfGroup = [NSMutableArray array];
//    
//    for(NSNumber *dutIndex in dutIndexSet)
//    {
//        if([globaldutIndexSet containsObject:dutIndex])
//        {
//            [enabledDUTIndexSetOfGroup addObject:dutIndex];
//        }
//    }
//    
//    if(enabledDUTIndexSetOfGroup.count > 0)
//    {
//        Fixture *mDevice = (Fixture *)[[JKDeviceManager sharedManager] deviceWithName:@"Fixture"];
//        BOOL motionOK = NO;
//        do
//        {
//            if([_synchLock tryLock])
//            {
//                motionOK = [mDevice runStartCommandsForGroup:groupIndex];
//                [_synchLock unlock];
//                motionOK = YES;
//                if(motionOK)
//                {
//                    NSMutableDictionary *snDic = [NSMutableDictionary dictionary];
//                    
//                    for(NSNumber *idx in enabledDUTIndexSetOfGroup)
//                    {
//                        [snDic setObject:[_snDic objectForKey:idx] forKey:idx];
//                    }
//                    
//                    [_testFlagSet setObject:[NSNumber numberWithBool:YES] forKey:groupIndex];
//                    
//                    _lbPrompt.stringValue = [NSString stringWithFormat:@"Testing...%@"
//                                             , [AppConfig config].loopTestEnabled && _manualTestFlag==NO ? [NSString stringWithFormat:@"\r\n(LoopTest: %d/%ld)", 1, [AppConfig config].loopTestTimes] : @""];
//                    [_dutContainer runTestWithSnSet:snDic];
//                    break;
//                }
//                [NSThread sleepForTimeInterval:0.2];
//            }
//            else{
//                [NSThread sleepForTimeInterval:0.01];
//            }
//        }while(_abortTest == NO);
//    }
//    
//    NSLog(@"Stop checking dut-group %@", groupIndex);
//}


- (IBAction)startTest:(id)sender
{
    [NSThread detachNewThreadWithBlock:^(){
        [_dutContainer runWithSnSet:_snDic];
    }];
}

-(IBAction)abortTest:(id)sender
{
    [_dutContainer abortTest];
    
    [_snDic removeAllObjects];
    snCount = 0;
    _tfSerialNumberEntry.stringValue = @"";
    
    _abortTest = YES;
    _btAbort.enabled = NO;
    _tfSerialNumberEntry.enabled = YES;
    [_tfSerialNumberEntry selectText:self];
    _manualTestFlag = NO;

    for(int gIdx = 1; gIdx <= [AppConfig config].ChannelGroup.count; gIdx++)
    {
        [_testFlagSet setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:gIdx]];
    }
    _lbPrompt.stringValue = @"Aborted";
    
    _btStart.enabled = NO;
}

- (BOOL)isTesting
{
    BOOL testFlag = NO;
    for(NSNumber *flag in _testFlagSet.allValues)
    {
        testFlag |= [flag boolValue];
    }
    return testFlag;
}

-(IBAction)showConfigWindow:(id)sender
{
    if([self isTesting] == NO)
    {
        if([[AppConfig config].globalLock tryLock])
        {
            [_window beginSheet:_cfgWindow.window completionHandler:^(NSModalResponse returnCode)
             {
                 dispatch_async(dispatch_get_main_queue(), ^(){
                     [self refresh: (returnCode == NSModalResponseOK) ? ScriptChanged : ScriptChanged|ConfigChanged];
                 });
                 [[AppConfig config].globalLock unlock];
             }];
        }
    }
}

-(IBAction)showLogWindow:(id)sender
{
    if([[AppConfig config].globalLock tryLock])
    {
        [_window beginSheet:_logWindow.window completionHandler:^(NSModalResponse returnCode)
         {
             [[AppConfig config].globalLock unlock];
         }];
    }
}

-(IBAction)showDebugWindow:(id)sender
{
    if([self isTesting] == NO)
    {
        if([[AppConfig config].globalLock tryLock])
        {
            [_window beginSheet:_debugWindow.window completionHandler:^(NSModalResponse returnCode)
             {
                 [[AppConfig config].globalLock unlock];
             }];
        }
    }
}


-(void)windowDidResize:(NSNotification *)notification
{
    [self refresh:ScriptChanged];
}

-(void)windowDidBecomeKey:(NSNotification *)notification
{
//    [_dutListView resizeView];
}

@end
