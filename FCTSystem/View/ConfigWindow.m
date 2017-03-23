//
//  ConfigWindow.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/19.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "ConfigWindow.h"
#import "AppConfig.h"
#import "AuthorizationWindow.h"

@interface ConfigWindow ()
{
    AuthorizationWindow         *_authWindow;
    IBOutlet NSTabView          *_tvMainTabView;
    
    /**** Outlet for Test-Config ****/
    /// Switch
    IBOutlet NSButton           *_cbPDCAEnabled;

    /// Device
    /// DMM
    IBOutlet NSTextField        *_tfSampleFreq;
    IBOutlet NSTextField        *_tfSampleCount;
    // Ethernet
    IBOutlet NSTextField        *_tfHost4F1;
    IBOutlet NSTextField        *_tfHost4F2;
    IBOutlet NSTextField        *_tfHost4F3;
    IBOutlet NSTextField        *_tfHost4F4;
    IBOutlet NSTextField        *_tfPort4F1;
    IBOutlet NSTextField        *_tfPort4F2;
    IBOutlet NSTextField        *_tfPort4F3;
    IBOutlet NSTextField        *_tfPort4F4;
    NSArray<NSTextField *>      *_tfHostPortSet;
    NSArray<NSComboBox *>       *_fixtureListSet;
    // SerialPort
    IBOutlet NSComboBox         *_cbPortList4DAQ1;
    IBOutlet NSComboBox         *_cbPortList4DAQ2;
    IBOutlet NSComboBox         *_cbPortList4DAQ3;
    IBOutlet NSComboBox         *_cbPortList4DAQ4;

    /// UART
    // ST(DUT)
    IBOutlet NSComboBox         *_cbPortList4UART1;
    IBOutlet NSComboBox         *_cbPortList4UART2;
    IBOutlet NSComboBox         *_cbPortList4UART3;
    IBOutlet NSComboBox         *_cbPortList4UART4;

    
    // JLink
    IBOutlet NSTextField        *_tfJLink1SN;
    IBOutlet NSTextField        *_tfJLink2SN;
    IBOutlet NSTextField        *_tfJLink3SN;
    IBOutlet NSTextField        *_tfJLink4SN;
    // WinPC
    IBOutlet NSTextField        *_tfWinPCIP;
    IBOutlet NSTextField        *_tfPort4WinServ1;
    IBOutlet NSTextField        *_tfPort4WinServ2;
    IBOutlet NSTextField        *_tfPort4WinServ3;
    IBOutlet NSTextField        *_tfPort4WinServ4;
    IBOutlet NSTextField        *_tfCCG2ConsoleProgrammer;
    IBOutlet NSTextField        *_tfCPLDConsoleProgrammer;
    IBOutlet NSTextField        *_tfDevNumber4MiniProg31;
    IBOutlet NSTextField        *_tfDevNumber4MiniProg32;
    IBOutlet NSTextField        *_tfDevNumber4MiniProg33;
    IBOutlet NSTextField        *_tfDevNumber4MiniProg34;
    IBOutlet NSTextField        *_tfXCFfilePath4Lattice1;
    IBOutlet NSTextField        *_tfXCFfilePath4Lattice2;
    IBOutlet NSTextField        *_tfXCFfilePath4Lattice3;
    IBOutlet NSTextField        *_tfXCFfilePath4Lattice4;
    IBOutlet NSTextField        *_tfPortAddr4Lattice1;
    IBOutlet NSTextField        *_tfPortAddr4Lattice2;
    IBOutlet NSTextField        *_tfPortAddr4Lattice3;
    IBOutlet NSTextField        *_tfPortAddr4Lattice4;
    
    NSArray<NSComboBox *>       *_portListSet;          //存储Port Path前缀是cu的串口配置控件
    
    
    NSArray<NSTextField *>      *_textControlSet;
    NSArray<NSTextField *>      *_tfNumberControlSet;
    
    IBOutlet NSComboBox         *_cbMotionPortList;
    
    //// Outlet for App-Config
//    IBOutlet NSButton           *_btAutoShowSimpleDUTView;
    IBOutlet NSButton           *_btDisplayResultByBackgroundColor;
    IBOutlet NSComboBox         *_cbXSpace;
    IBOutlet NSComboBox         *_cbYSpace;
    IBOutlet NSComboBox         *_cbXMargin;
    IBOutlet NSComboBox         *_cbYMargin;
    IBOutlet NSComboBox         *_cbOrderModeInRow;
    IBOutlet NSComboBox         *_cbOrderModeInColumn;
    IBOutlet NSButton           *_btSynchItemState4AllDUTs;

    IBOutlet NSButton           *_btLoopTestEnabled;
    IBOutlet NSComboBox         *_cbLoopTestTimes;
    IBOutlet NSTextField        *_tfLoopTestInterval;
    
    IBOutlet NSButton           *_cbDebugEnabled;
    IBOutlet NSButton           *_cbStartTestByButton;
    IBOutlet NSComboBox         *_cbDUTCount;
    IBOutlet NSComboBox         *_cbSNLength;
    
    IBOutlet NSComboBox         *_cbScriptList;
    IBOutlet NSComboBox         *_cbStepRunLevel;
    
    IBOutlet NSTableView        *_tvRunModeList;
    NSMutableArray              *_supportedRunModes;
    IBOutlet NSComboBox         *_cbInitialMode;
    
    BOOL            _hasAuthorization;
}

@end

@implementation ConfigWindow

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
//        _bcdListSet    = @[_cbPortList4BCD1, _cbPortList4BCD2, _cbPortList4BCD3, _cbPortList4BCD4];
        _portListSet    = @[_cbPortList4UART1, _cbPortList4UART2, _cbPortList4UART3, _cbPortList4UART4
                            , _cbPortList4DAQ1, _cbPortList4DAQ2, _cbPortList4DAQ3, _cbPortList4DAQ4
                            , _cbMotionPortList];
        _textControlSet = @[_tfHost4F1, _tfHost4F2, _tfHost4F3, _tfHost4F4
                            ,_tfJLink1SN, _tfJLink2SN, _tfJLink3SN, _tfJLink4SN
                            , _tfWinPCIP
                            , _tfCCG2ConsoleProgrammer, _tfCPLDConsoleProgrammer
                            , _tfDevNumber4MiniProg31, _tfDevNumber4MiniProg32, _tfDevNumber4MiniProg33, _tfDevNumber4MiniProg34
                            , _tfXCFfilePath4Lattice1, _tfXCFfilePath4Lattice2, _tfXCFfilePath4Lattice3, _tfXCFfilePath4Lattice4
                            , _tfPortAddr4Lattice1, _tfPortAddr4Lattice2, _tfPortAddr4Lattice3, _tfPortAddr4Lattice4];
        _tfNumberControlSet = @[_tfSampleFreq, _tfSampleCount
                                , _tfPort4F1, _tfPort4F2, _tfPort4F3, _tfPort4F4
                                , _tfPort4WinServ1, _tfPort4WinServ2, _tfPort4WinServ3, _tfPort4WinServ4];
        
        _authWindow     = [[AuthorizationWindow alloc] init];
        
        _hasAuthorization = NO;
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowWillClose:(NSNotification *)notification
{
    _hasAuthorization = NO;
}

-(void)windowDidBecomeKey:(NSNotification *)notification
{
    /**** Initialize Test-Config ****/
    /// Switch
    _cbPDCAEnabled.state            = [AppConfig config].pdcaEnabled;
    _cbDebugEnabled.state           = [AppConfig config].debugEnabled;
    _cbStartTestByButton.state      = [AppConfig config].startTestByButton;
    /// Device
    NSArray *portPaths = [JKSerialPort portPaths];
    for(NSComboBox *cb in _portListSet)
    {
        [cb removeAllItems];
        [cb addItemsWithObjectValues:portPaths];
        
        id value = [[AppConfig config] valueForKeyPath:[NSString stringWithFormat:@"Devices.%@", cb.identifier]];
        NSString *currentFixturePort = value ? value : @"";
        NSInteger index = [cb indexOfItemWithObjectValue:currentFixturePort];
        if(index == NSNotFound)
        {
            NSAttributedString *attValue = [[NSAttributedString alloc] initWithString:currentFixturePort
                                                                           attributes:@{NSForegroundColorAttributeName:[NSColor lightGrayColor]}];
            [cb addItemWithObjectValue:attValue];
        }
        else
        {
            [cb removeItemAtIndex:index];
            NSAttributedString *attValue = [[NSAttributedString alloc] initWithString:currentFixturePort
                                                                           attributes:@{NSForegroundColorAttributeName:[NSColor colorWithRed:34/255.0 green:200/255.0 blue:34/255.0 alpha:1]}];
            [cb addItemWithObjectValue:attValue];
        }
        index = cb.numberOfItems-1;
        [cb selectItemAtIndex:index];
        
        cb.delegate = self;
    }
    
    /// UART Initialization
    
    for(NSTextField *tf in _textControlSet)
    {
        id value = [[AppConfig config] valueForKeyPath:[NSString stringWithFormat:@"Devices.%@", tf.identifier]];
        tf.stringValue = value ? [NSString stringWithFormat:@"%@", value] : @"";
        tf.textColor = [NSColor blackColor];
    }
    
    for(NSTextField *tf in _tfNumberControlSet)
    {
        id value = [[AppConfig config] valueForKeyPath:[NSString stringWithFormat:@"Devices.%@", tf.identifier]];
        tf.stringValue = value ? [NSString stringWithFormat:@"%@", value] : @"";
        tf.textColor = [NSColor blackColor];
    }
    
    NSMutableArray *scriptPaths = [NSMutableArray array];
    NSArray * paths = [[NSFileManager defaultManager] subpathsAtPath:[NSString stringWithFormat:@"%@/testerconfig/", NSHomeDirectory()]];
    for(NSString *path in paths)
    {
        NSString *fileName = [path lastPathComponent];
        if([fileName hasSuffix:@".csv"])
        {
            [scriptPaths addObject:fileName];
        }
    }
    [_cbScriptList removeAllItems];
    [_cbScriptList addItemsWithObjectValues:scriptPaths];
    [_cbScriptList selectItemWithObjectValue:[AppConfig config].testPlanName];
    
    [_cbStepRunLevel selectItemAtIndex:[AppConfig config].appStepRunLevel];
    
    
    /// Initialize App-Config
//    _btAutoShowSimpleDUTView.state              = [AppConfig config].autoShowSimpleDUTView;
    _btDisplayResultByBackgroundColor.state     = [AppConfig config].displayResultByBackgoundColor;
    [_cbXMargin selectItemWithObjectValue:[NSString stringWithFormat:@"%d",[AppConfig config].xMargin]];
    [_cbYMargin selectItemWithObjectValue:[NSString stringWithFormat:@"%d",[AppConfig config].yMargin]];
    [_cbXSpace selectItemWithObjectValue:[NSString stringWithFormat:@"%d",[AppConfig config].xSpaceBetweenDUTs]];
    [_cbYSpace selectItemWithObjectValue:[NSString stringWithFormat:@"%d",[AppConfig config].ySpaceBetweenDUTs]];
    [_cbOrderModeInRow selectItemAtIndex:[AppConfig config].orderModeInRow];
    [_cbOrderModeInColumn selectItemAtIndex:[AppConfig config].orderModeInColumn];
    _btSynchItemState4AllDUTs.state             = [AppConfig config].synchItemState4AllDUTs;

    [_cbDUTCount selectItemWithObjectValue:[NSString stringWithFormat:@"%d", [AppConfig config].dutCount]];
    
    [_cbSNLength selectItemWithObjectValue:[NSString stringWithFormat:@"%ld",[AppConfig config].snLength]];
    _btLoopTestEnabled.state        = [AppConfig config].loopTestEnabled;
    [_cbLoopTestTimes selectItemWithObjectValue:[NSString stringWithFormat:@"%ld", [AppConfig config].loopTestTimes]];
    _tfLoopTestInterval.stringValue = [NSString stringWithFormat:@"%.3lf", [AppConfig config].loopInterval];
    
    /// Run mode
    _supportedRunModes = [[AppConfig config].supportedRunModes mutableCopy];
    [_cbInitialMode removeAllItems];
    [_cbInitialMode addItemsWithObjectValues:_supportedRunModes];
    [_cbInitialMode selectItemWithObjectValue:[JKAppConfig config].initialRunMode];
    _cbInitialMode.delegate = self;
    
    if(_hasAuthorization == NO)
    {
        [_tvMainTabView selectTabViewItemAtIndex:0];
        [self.window beginSheet:_authWindow.window completionHandler:^(NSModalResponse returnCode){
            if(returnCode == NSModalResponseOK)
            {
                
                _hasAuthorization = YES;
            }
            else
            {
                [self quit:self];
            }
        }];
    }
}

static BOOL editorCloseFlag = YES;
-(IBAction)showScriptEditor:(id)sender
{
    if(editorCloseFlag)
    {
        editorCloseFlag = NO;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [AppConfig config].testPlanName];
        
        NSString *appPath = [NSString stringWithFormat:@"%@/Contents/MacOS/JKScriptEditor", [[NSBundle mainBundle] pathForResource:@"JKScriptEditor" ofType:@"app"]];
        
        //    NSError *err = nil;
        //    [[NSWorkspace sharedWorkspace] launchApplicationAtURL:[NSURL URLWithString:appPath]
        //                                                  options:NSWorkspaceLaunchDefault configuration:@{NSWorkspaceLaunchConfigurationArguments:@[path]} error:&err];
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = appPath;
        task.arguments = @[@"-ScriptPath", path];
        [task launch];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scriptEditorClosed:) name:NSTaskDidTerminateNotification object:task];
    }
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"The script Editor has been opened";
        alert.informativeText = @"";
        [alert runModal];
    }
    
//    [NSPipe pipe];
}

- (void)scriptEditorClosed:(NSTask *)task
{
    editorCloseFlag = YES;
}

- (IBAction)quit:(id)sender
{
    if(editorCloseFlag == NO)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"The script Editor isn't closed";
        alert.informativeText = @"";
        [alert runModal];
        return;
    }
    
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
    [self.window close];
}

- (IBAction)saveTestConfig:(id)sender
{
    if(editorCloseFlag == NO)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"The script Editor isn't closed";
        alert.informativeText = @"";
        [alert runModal];
        return;
    }
    
    [self saveChanges];
    
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    [self.window close];
}

-(IBAction)saveAppConfig:(id)sender
{
    if(editorCloseFlag == NO)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"The script Editor isn't closed";
        alert.informativeText = @"";
        [alert runModal];
        return;
    }
    
    [self saveChanges];
    
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    [self.window close];
}

-(void)saveChanges
{
    //// Save Test Config
    // Save switch config
    [AppConfig config].pdcaEnabled          = _cbPDCAEnabled.state;
    [AppConfig config].debugEnabled         = _cbDebugEnabled.state;
    [AppConfig config].startTestByButton    = _cbStartTestByButton.state;
    // Save device config
    
    for(NSComboBox *cb in _portListSet)
    {
        if([cb.stringValue isNotEqualTo:@""])
        {
            NSString *keyPath = [NSString stringWithFormat:@"Devices.%@", cb.identifier];
            [[AppConfig config] setValue:cb.stringValue forKeyPath:keyPath];
            if([keyPath containsString:@"ST_UART"])
            {
                [[AppConfig config] setValue:[cb.stringValue stringByReplacingOccurrencesOfString:@"cu." withString:@"tty."]
                                  forKeyPath:[keyPath stringByReplacingOccurrencesOfString:@"ST_UART" withString:@"BCD_UART"]];
            }
        }
    }
    
//    for(NSComboBox *cb in _bcdListSet)
//    {
//        if([cb.stringValue isNotEqualTo:@""])
//        {
//            [[AppConfig config] setValue:cb.stringValue forKeyPath:[NSString stringWithFormat:@"Devices.%@", cb.identifier]];
//        }
//    }
    
    for(NSControl *cb in _textControlSet)
    {
        if([cb.stringValue isNotEqualTo:@""])
        {
            [[AppConfig config] setValue:cb.stringValue forKeyPath:[NSString stringWithFormat:@"Devices.%@", cb.identifier]];
        }
    }
    
    for(NSControl *cb in _tfNumberControlSet)
    {
        if([cb.stringValue isNotEqualTo:@""])
        {
            [[AppConfig config] setValue:[NSNumber numberWithDouble:[[cb.stringValue stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]] forKeyPath:[NSString stringWithFormat:@"Devices.%@", cb.identifier]];
        }
    }
    
    NSString *scriptName = _cbScriptList.stringValue;
    if([scriptName pathExtension] == nil || [[scriptName pathExtension] isEqualTo:@""])
    {
        scriptName = [scriptName stringByAppendingPathExtension:@"plist"];
    }
    [AppConfig config].testPlanName = scriptName;
    [AppConfig config].appStepRunLevel = (STEPRUN_LEVEL)_cbStepRunLevel.indexOfSelectedItem;

    
    //// Save App Config
    [AppConfig config].dutCount                         = [_cbDUTCount.stringValue intValue];
//    [AppConfig config].autoShowSimpleDUTView            = _btAutoShowSimpleDUTView.state;
    [AppConfig config].displayResultByBackgoundColor    = _btDisplayResultByBackgroundColor.state;
    [AppConfig config].xMargin                          = [_cbXMargin.stringValue intValue];
    [AppConfig config].yMargin                          = [_cbYMargin.stringValue intValue];
    [AppConfig config].xSpaceBetweenDUTs                = [_cbXSpace.stringValue intValue];
    [AppConfig config].ySpaceBetweenDUTs                = [_cbYSpace.stringValue intValue];
    [AppConfig config].orderModeInRow                   = (int)_cbOrderModeInRow.indexOfSelectedItem;
    [AppConfig config].orderModeInColumn                = (int)_cbOrderModeInColumn.indexOfSelectedItem;
    [AppConfig config].synchItemState4AllDUTs           = _btSynchItemState4AllDUTs.state;
    
    [AppConfig config].snLength                         = [_cbSNLength.stringValue intValue];
    [AppConfig config].loopTestEnabled                  = _btLoopTestEnabled.state;
    [AppConfig config].loopTestTimes                    = [_cbLoopTestTimes.stringValue integerValue];
    [AppConfig config].loopInterval                     = [_tfLoopTestInterval.stringValue doubleValue];
    
    /// RunMode
    [AppConfig config].supportedRunModes = _supportedRunModes;
    [AppConfig config].initialRunMode = _cbInitialMode.stringValue;
    
    [[AppConfig config] synchronize];
}

-(void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    NSComboBox *cb = (NSComboBox *)notification.object;
    if(cb)
    {
        if([cb.objectValueOfSelectedItem isKindOfClass:NSAttributedString.class])
        {
            NSAttributedString *attString = (NSAttributedString *)cb.objectValueOfSelectedItem;
            cb.textColor = (NSColor *)[attString attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        }
        else
        {
            cb.textColor = [NSColor textColor];
        }
    }
}

- (void)comboBoxWillPopUp:(NSNotification *)notification
{
    NSComboBox *cb = (NSComboBox *)notification.object;
    if(cb)
    {
        if([cb.identifier hasSuffix:@".DevPath"])
        {
            NSArray *pathSet = [JKSerialPort portPaths];
            [cb removeAllItems];
            [cb addItemsWithObjectValues:pathSet];
            
            id value = [[AppConfig config] valueForKeyPath:[NSString stringWithFormat:@"Devices.%@", cb.identifier]];
            NSString *currentFixturePort = value ? value : @"";
            NSInteger index = [cb indexOfItemWithObjectValue:currentFixturePort];
            if(index == NSNotFound)
            {
                NSAttributedString *attValue = [[NSAttributedString alloc] initWithString:currentFixturePort
                                                                               attributes:@{NSForegroundColorAttributeName:[NSColor lightGrayColor]}];
                [cb addItemWithObjectValue:attValue];
            }
            else
            {
                [cb removeItemAtIndex:index];
                NSAttributedString *attValue = [[NSAttributedString alloc] initWithString:currentFixturePort
                                                                               attributes:@{NSForegroundColorAttributeName:[NSColor colorWithRed:34/255.0 green:200/255.0 blue:34/255.0 alpha:1]}];
                [cb addItemWithObjectValue:attValue];
            }
        }
        else if([cb.identifier hasSuffix:@"RunMode"])
        {
            [cb removeAllItems];
            [cb addItemsWithObjectValues:_supportedRunModes];
            [cb selectItemWithObjectValue: [cb.identifier hasPrefix:@"Initial"] ? [JKAppConfig config].initialRunMode : [JKAppConfig config].currentRunMode];
        }
    }
}


//-(BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem
//{
//    BOOL __block retCode = YES;
//    if([tabViewItem.identifier isEqualTo:@"AppConfig"])
//    {
//        NSTabViewItem *lastItem = tabView.selectedTabViewItem;
//        [self.window beginSheet:_authWindow.window completionHandler:^(NSModalResponse returnCode){
//            if(returnCode != NSModalResponseOK)
//            {
//                [tabView selectTabViewItem:lastItem];
//            }
//        }];
//    }
//    
//    return retCode;
//}

- (IBAction)addRunMode:(NSButton *)sender
{
    [_supportedRunModes addObject:@"New Run Mode"];
    [_tvRunModeList reloadData];
}

- (IBAction)deleteRunMode:(NSButton *)sender
{
    if(_tvRunModeList.selectedRow >= 0 && _tvRunModeList.selectedRow < _supportedRunModes.count)
    {
        [_supportedRunModes removeObjectAtIndex:_tvRunModeList.selectedRow];
    }
    [_tvRunModeList reloadData];
}

- (IBAction)modifyRunMode:(NSTextField *)sender
{
    NSInteger row = [_tvRunModeList rowForView:sender];
    if(row != NSNotFound)
    {
        _supportedRunModes[row] = sender.stringValue;
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _supportedRunModes.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if([tableView.identifier isEqualTo:@"RunModeList"])
    {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        
        cellView.textField.stringValue = _supportedRunModes[row];
        cellView.textField.editable = YES;
        
        return cellView;
    }
    
    return nil;
}

static dispatch_once_t ipMatchInitOnceToken;
static NSRegularExpression *ipRegex;
-(void)controlTextDidChange:(NSNotification *)obj
{
    dispatch_once(&ipMatchInitOnceToken, ^(){
        NSError *err = nil;
        ipRegex = [[NSRegularExpression alloc] initWithPattern:@"(([1-9])|([1-9][0-9])|([1-2][0-9]{2}))\\.(([1-9])|([1-9][0-9])|([1-2][0-9]{2}))\\.(([1-9])|([1-9][0-9])|([1-2][0-9]{2}))\\.(([1-9])|([1-9][0-9])|([1-2][0-9]{2}))" options:0 error:&err];
    });
    NSTextField *tf = obj.object;
    if(tf && [tf.identifier containsString:@"ServerIP"])
    {
        NSTextCheckingResult *result = [ipRegex firstMatchInString:tf.stringValue options:0 range:NSMakeRange(0, tf.stringValue.length)];
        tf.textColor = result && result.range.location != NSNotFound ? [NSColor blackColor] : [NSColor redColor];
//        for(NSTextField *t in _textControlSet)
//        {
//            if([t.identifier containsString:@"ServerIP"])
//            {
//                t.stringValue = tf.stringValue;
//                t.textColor = tf.textColor;
//            }
//        }
    }
}

@end
