//
//  DUTView.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "DUTView.h"
#import "AppConfig.h"
#import "Sequence.h"

#import "ZMQPorts.h"
#import "JKZMQObjC.h"

#import "Subcriber.h"
#import "RPCRequester.h"


@interface DUTView ()<MessageHandlerProtocol>
{
    /// Outlet for simlpe info view
    IBOutlet JKView                 *_simpleContentView;
    IBOutlet JKView                 *_simpleInfoView;
    IBOutlet NSTextField            *_tfSerialNumberSimple;
    IBOutlet NSProgressIndicator    *_piPropressIndicator;
    IBOutlet NSTextField            *_tfItemCounter;
    IBOutlet NSImageView            *_ivResultSimple;
    IBOutlet NSTextField            *_tfSlotNumberSimple;
    IBOutlet NSButton               *_btEnabledSimple;
    NSSize                          _originalSimpleViewSize;
    IBOutlet NSTextField            *_tfCycleTime;
    
    ///  Outlet for full info view
    IBOutlet JKView                 *_normalInfoView;
//    IBOutlet NSTextField            *_tfSerialNumberNormal;
//    IBOutlet NSImageView            *_ivResultNormal;
    IBOutlet NSScrollView           *_svLogScroller;
    IBOutlet NSTextView             *_tvLogShower;
//    IBOutlet NSTextField            *_tfSlotNumberNormal;
//    IBOutlet NSButton               *_btEnabledNormal;
    NSSize                          _originalNormalViewSize;
    IBOutlet NSMenuItem             *_miTestSelectedItem;
    IBOutlet NSMenuItem             *_miEnableAllItems;
    IBOutlet NSMenuItem             *_miDisableAllItems;
    IBOutlet NSMenuItem             *_miExpandAllItems;
    IBOutlet NSMenuItem             *_miCollapseAllItems;
    

    
    IBOutlet NSTabView          *_sequenceTabView;
    IBOutlet NSScrollView       *_scrollView;
    IBOutlet NSOutlineView      *_normalSequenceTable;
    IBOutlet NSOutlineView      *_failItemTable;
    NSInteger _selectedRow, _selectedCol;
    
    DUT_RESULTDISPLAYTYPE       _resultDisplayType;
    
    /// test info
    TestEngine       *_testEngine;
    NSInteger           _itemIndex;
    
    NSArray<__kindof NSColor *>     *_defaultCellColorSet;
    
    NSThread        *_testThread;
    BOOL            _manualTestFlag;
    
    //simulate control
//    IBOutlet NSButton               *_btSimulate;
    
    NSString        *_scripteName;
    
    NSInteger       loopTimes;
    
    dispatch_block_t    reloadDataBlock;
    
    Sequence        *_sequence;
    NSMutableArray  *_failItemSet;
    
    ///RPC
    Subcriber           *_subcriberOfSM;
    Subcriber           *_subcriberOfSQ;
    Subcriber           *_subcriberOfTE;
    RPCRequester        *_requesterToSQ;
    
    JKTimer             *_timer4SQ;
    JKTimer             *_timer4Item;
    JKTimer             *_timer4ReloadData;
    TestItem            *_currentItem;
    NSMutableIndexSet   *_rowBuffer;
}

@end

@implementation DUTView

static NSDictionary<NSNumber *, __kindof NSImage *> *itemRstLedDic;
static NSDictionary<NSNumber *, __kindof NSImage *> *globalRstImageDic;
static NSDictionary<NSNumber *, __kindof NSImage *> *globalRstLedDic;
static NSArray<NSString *>                          *rstStringSet;
static NSDictionary<NSNumber *, __kindof NSColor *> *rstColorDic;
static dispatch_once_t  token;

static NSColor *_defaultColorOfRow;         //默认行背景色
static NSColor *_selectedColorOfRow;        //选中行背景色
static NSColor *_disableColorOfRow;         //禁测项行背景色
static NSColor *_passColorOfRow;
static NSColor *_failColorOfRow;

//@synthesize refTestEngine = _testEngine, manualTestFlag = _manualTestFlag;

- (void)awakeFromNib
{
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_DUT_SELECTED object:self];
    _simpleContentView.backgroundColor = _simpleInfoView.backgroundColor = [NSColor whiteColor];
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
    }
    
    return self;
}

- (instancetype)initForSite:(NSInteger)site
{
    self = [super init];
    
    if(self)
    {
        _site = site;
        if(rstStringSet == nil)
        {
            dispatch_once(&token, ^(){
                rstStringSet = [NSArray arrayWithObjects:@"FAIL", @"PASS", @"", @"", @"", @"", @"", @"- - - -", nil];
                itemRstLedDic = @{[NSNumber numberWithInteger:TR_PASS]:[AppConfig config].imgGreenLed,
                                  [NSNumber numberWithInteger:TR_FAIL]:[AppConfig config].imgRedLed,
                                  [NSNumber numberWithInteger:TR_TESTING]:[AppConfig config].imgYellowLed,
                                  [NSNumber numberWithInteger:TR_NONE]:[AppConfig config].imgGrayLed};
                globalRstImageDic = @{[NSNumber numberWithInteger:TR_PASS]:[AppConfig config].imgPass,
                                      [NSNumber numberWithInteger:TR_FAIL]:[AppConfig config].imgFail,
                                      [NSNumber numberWithInteger:TR_COMM_ERR]:[AppConfig config].imgCommErr,
                                      [NSNumber numberWithInteger:TR_FATAL_ERR]:[AppConfig config].imgFatalErr,
                                      [NSNumber numberWithInteger:TR_ABORT4FAIL]:[AppConfig config].imgFail,
                                      [NSNumber numberWithInteger:TR_ABORT4OP]:[AppConfig config].imgAbort,
                                      [NSNumber numberWithInteger:TR_NONE]:[AppConfig config].imgNone};
                globalRstLedDic = @{[NSNumber numberWithInteger:TR_PASS]:[AppConfig config].imgGreenLed,
                                    [NSNumber numberWithInteger:TR_FAIL]:[AppConfig config].imgRedLed,
                                    [NSNumber numberWithInteger:TR_TESTING]:[AppConfig config].imgYellowLed,
                                    [NSNumber numberWithInteger:TR_COMM_ERR]:[AppConfig config].imgRedLed,
                                    [NSNumber numberWithInteger:TR_FATAL_ERR]:[AppConfig config].imgRedLed,
                                    [NSNumber numberWithInteger:TR_ABORT4FAIL]:[AppConfig config].imgRedLed,
                                    [NSNumber numberWithInteger:TR_ABORT4OP]:[AppConfig config].imgRedLed,
                                    [NSNumber numberWithInteger:TR_NONE]:[AppConfig config].imgGrayLed};
                
//                NSColor *defaultColor = [NSColor colorWithRed:160/255.0 green:82/255.0 blue:45/255.0 alpha:1];    //褐色
//                NSColor *defaultColor = [NSColor colorWithRed:202/255.0 green:235/255.0 blue:216/255.0 alpha:1];    //天蓝灰
                NSColor *defaultColor = [NSColor colorWithRed:251/255.0 green:255/255.0 blue:242/255.0 alpha:1];
                NSColor *defaultAlternateColor = [NSColor whiteColor];
                rstColorDic = @{[NSNumber numberWithInteger:TR_PASS]:[NSColor greenColor],
                                [NSNumber numberWithInteger:TR_FAIL]:[NSColor redColor],
                                [NSNumber numberWithInteger:TR_TESTING]:[NSColor yellowColor],
                                [NSNumber numberWithInteger:TR_NONE]:@[defaultColor, defaultAlternateColor]};
                _defaultColorOfRow = defaultColor;
                _selectedColorOfRow = [NSColor yellowColor];
                _disableColorOfRow  = [NSColor lightGrayColor];
                _passColorOfRow = [NSColor greenColor];
                _failColorOfRow = [NSColor redColor];
                
                colorSet = @[[NSColor grayColor], [NSColor yellowColor], [NSColor redColor]];
            });
        }
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
        
        ((JKView *)_simpleInfoView).delegate = self;
        _simpleView = _simpleInfoView;
        _normalView = _normalInfoView;
        
        _originalSimpleViewSize = _simpleInfoView.frame.size;
        _originalNormalViewSize = _normalInfoView.frame.size;
        
        _visableView = _simpleInfoView;
        
        _selectedRow = _selectedCol = -1;
        
        _resultDisplayType = DUT_RDT_IMAGE;
        
        _testEngine = [[TestEngine alloc] initForSite:_site];
        _tfSlotNumberSimple.stringValue = [NSString stringWithFormat:@"#%ld", _site+1];
        _tfItemCounter.stringValue = [NSString stringWithFormat:@"0/N"];
        
        loopTimes = 0;
        _manualTestFlag = NO;
        
        _sequence = [[Sequence alloc] init];
        [_sequence loadSequence:[AppConfig config].testPlanName];
        _failItemSet = [NSMutableArray array];
        
        ///RPC
        // 初始化 GUI Requester
        NSString *identifier    = @"DUT_GUI";
        _requesterToSQ      = [[RPCRequester alloc] initWithIdentifier:identifier
                                                              endpoint:[NSString stringWithFormat:@"tcp://localhost:%ld", [ZMQPorts sharedZMQPorts].SEQUENCER_PORT+site]];
        
        // 初始化 StateMachine 的 Subcriber
        _subcriberOfSM      = [[Subcriber alloc] initWithIdentifier:identifier
                                                           endpoint:[NSString stringWithFormat:@"tcp://localhost:%ld", [ZMQPorts sharedZMQPorts].STATEMACHINE_PUB]];
        [_subcriberOfSM subcribe4Caller:self];
        
        // 初始化 Sequencer 的 Subcriber
        _subcriberOfSQ      = [[Subcriber alloc] initWithIdentifier:identifier
                                                            endpoint:[NSString stringWithFormat:@"tcp://localhost:%ld", [ZMQPorts sharedZMQPorts].SEQUENCER_PUB+site]];
        [_subcriberOfSQ subcribe4Caller:self];
        
        // 初始化 TestEngine 的 Subcriber
//        _subcriberOfTE      = [[Subcriber alloc] initWithIdentifier:identifier
//                                                            context:_zmqContext
//                                                           endpoint:[NSString stringWithFormat:@"tcp://localhost:%ld", [ZMQPorts sharedZMQPorts].TEST_ENGINE_PUB+site]];
//        [_subcriberOfTE subcribe4Caller:self];
        
        _timer4SQ           = [JKTimer timer];
        _timer4Item         = [JKTimer timer];
        _timer4ReloadData   = [JKTimer timer];
        _rowBuffer          = [NSMutableIndexSet indexSet];
    }
    
    return self;
}


#define kEvent_StartTest            0
#define kEvent_EndTest              1
#define kEvent_ItemStart            2
#define kEvent_ItemFinish           3
#define kEvent_AttributeFound       4
#define kEvent_UOPDetected          6

- (NSString *)handleMessage:(NSArray *)message
{
    id msgData = [message lastObject];
    if([msgData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dicData = (NSDictionary *)msgData;
        if([dicData.allKeys containsObject:kZMQ_Event])
        {
            int event = [[dicData objectForKey:kZMQ_Event] intValue];
            [self handleEvent:event data:[dicData objectForKey:kZMQ_Data]];
        }
    }
    else
    {
        [self showMessage:[JKLogMessage msgWithInfo:msgData]];
    }
    
    return nil;
}

#define kRefreshInterver        1
- (void)handleEvent:(int)event data:(NSDictionary *)dataDic
{
    switch (event) {
        case kEvent_StartTest:
        {
            _isTesting = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_DUT_STARTTEST object:self userInfo:nil];
            [_timer4SQ start];
            [_timer4ReloadData start];
            [_failItemSet removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [_sequenceTabView selectTabViewItemAtIndex:0];
                [_normalSequenceTable scrollRowToVisible:0];
                _ivResultSimple.image = [globalRstLedDic objectForKey:@(RST_TESTING)];
            });
            [self showMessage:nil];
            [NSThread detachNewThreadSelector:@selector(updateTime) toTarget:self withObject:nil];
        }
            break;
        case kEvent_EndTest:
        {
            _isTesting = NO;
            self.testResult = [[dataDic objectForKey:@"resutl"] boolValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_DUT_ENDTEST object:self userInfo:nil];

            dispatch_async(dispatch_get_main_queue(), ^(){
                _ivResultSimple.image = [globalRstLedDic objectForKey:@(self.testResult)];
                
                if(_failItemSet.count)
                {
                    [_sequenceTabView selectTabViewItemAtIndex:1];
                    [_failItemTable reloadData];
                }
            });
        }
            break;
        case kEvent_ItemStart:
        {
            [_timer4Item start];
            
            NSString *tid = [dataDic objectForKey:@"tid"];
            NSString *group = [dataDic objectForKey:@"group"];
            for(TestItem *item in _sequence.items)
            {
                if([item.group isEqualTo:group] && [item.tid isEqualTo:tid])
                {
                    _currentItem = item;
                    _currentItem.result = RST_TESTING;
                    
                    @synchronized (_rowBuffer) {
                        [_rowBuffer addIndex:[_normalSequenceTable rowForItem:_currentItem]];
                    }
                }
            }
        }
            break;
        case kEvent_ItemFinish:
        {
            NSString *tid = [dataDic objectForKey:@"tid"];
            if([_currentItem.tid isEqualTo:tid])
            {
                BOOL isPass = [[dataDic objectForKey:@"result"] boolValue];
                if(!isPass)
                {
                    [_failItemSet addObject:_currentItem];
                }
                
                _currentItem.value = [dataDic objectForKey:@"value"];
                _currentItem.result = isPass;
                _currentItem.cycleTime = _timer4Item.durationInSecond;
                
                if(_timer4ReloadData.durationInSecond > kRefreshInterver)
                {
//                    @synchronized (_rowBuffer) {
                        NSIndexSet *rowIndexes = [_rowBuffer copy];
                        [_rowBuffer removeAllIndexes];
                        NSIndexSet *colIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([_normalSequenceTable columnWithIdentifier:@"value"], 2)];
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [_normalSequenceTable reloadDataForRowIndexes:rowIndexes columnIndexes:colIndexes];
                            [_normalSequenceTable scrollRowToVisible:[rowIndexes lastIndex]];
                            
                            [_failItemTable reloadData];
//                            [_normalSequenceTable setNeedsDisplay];
                            
                        });
                    
                    
//                    }

                    [_timer4ReloadData start];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)updateTime
{
    JKTimer *timer = [JKTimer timer];
    [timer start];
    while(self.isTesting)
    {
        NSString *testTime = [NSString stringWithFormat:@"CT:%.1lf(s)",timer.durationInSecond];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            _tfCycleTime.stringValue = testTime;
        });
        
        if(self.isTesting)
        {
            [NSThread sleepForTimeInterval:0.5];
        }
        else
        {
            break;
        }
    }
}

- (void)close
{
    [_testEngine close];
    [_subcriberOfTE close];
    [_subcriberOfSM close];
    [_subcriberOfSQ close];
    [_requesterToSQ close];
}


- (void)viewWillAppear
{
//    [self refresh];
//    [_normalSequenceTable scrollRowToVisible:0];
//    [_ovItemView scrollPoint:NSMakePoint(0, 0)];
}


- (void)setFrame:(NSRect )frame
{
    _simpleInfoView.frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, _simpleInfoView.frame.size.height);
    _normalInfoView.frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height > _originalNormalViewSize.height ? frame.size.height : _originalNormalViewSize.height);;
    [self refresh];
}

- (NSRect)frame
{
    return _visableView.frame;
}

- (NSSize)normalSize
{
    return _normalInfoView.frame.size;
}

- (NSSize)simpleSize
{
    return _simpleInfoView.frame.size;
}

- (void)setResultDisplayType:(DUT_RESULTDISPLAYTYPE)resultDisplayType
{
    _resultDisplayType = resultDisplayType;
    [self refresh];
}

- (DUT_RESULTDISPLAYTYPE)resultDisplayType
{
    return _resultDisplayType;
}

- (BOOL)enabled
{
    return _btEnabledSimple.state;
}

- (void)setEnabled:(BOOL)enabled
{
    [self willChangeValueForKey:@"enabled"];
    _btEnabledSimple.state = enabled;
    [self didChangeValueForKey:@"enabled"];
}

- (BOOL)controllable
{
    return _btEnabledSimple.enabled;
}

-(void)setControllable:(BOOL)controllable
{
    _btEnabledSimple.enabled = controllable;
}

- (void)runWithSN:(NSString *)serialNumber
{
    [self setSerialNumber:serialNumber];
    [_sequence reset];
    
    // Test
//    dispatch_async(dispatch_get_main_queue(), ^(){      //
    [_requesterToSQ send:@"load" args:@[@"/Users/Jack/Desktop/test_plan__1.0.0_1.0.0.csv"]];
        [self showMessage:[JKLogMessage msgWithInfo:[_requesterToSQ receive]]];
        
        [NSThread sleepForTimeInterval:1];
        [_requesterToSQ send:@"run"];
        [self showMessage:[JKLogMessage msgWithInfo:[_requesterToSQ receive]]];
//        [_requesterToSQ receive];
//    });
}

- (IBAction)testSelectedItems:(id)sender
{//待完善－处理多选的情况（子测试项与父测试项的关联）
    
//    NSInteger selectedRow = _ovItemView.selectedRow;
    
    _manualTestFlag = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kManualTestStartNotification object:nil];
}


- (void)abortTest
{
    [_testThread cancel];
    self.controllable = YES;
}

- (void)setSerialNumber:(NSString *)serialNumber
{
//    _testEngine.serialNumber = serialNumber;
    dispatch_async(dispatch_get_main_queue(), ^(){
        _tfSerialNumberSimple.stringValue = serialNumber;
    });;
}


static NSDateFormatter  *dateFormatter;
static dispatch_once_t failOpOnceToken;
static NSRegularExpression *failOpRegex;
static NSArray<__kindof NSColor*> *colorSet;
- (void)showMessage:(JKLogMessage *)logMessage
{
    dispatch_once(&failOpOnceToken, ^(){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"#hh:mm:ss.SSS# ";
        NSError *err = nil;
        failOpRegex = [[NSRegularExpression alloc] initWithPattern:@"result: FAIL" options:0 error:&err];
    });
    if(logMessage)
    {
        NSString *fmtMsg = [[NSString alloc] initWithFormat:@"%@%@\n", [dateFormatter stringFromDate:[NSDate date]], logMessage.message] ;
        NSAttributedString *attMsg = [[NSAttributedString alloc] initWithString:fmtMsg];
        NSArray *matches = [failOpRegex matchesInString:logMessage.message options:0 range:NSMakeRange(0, logMessage.message.length)];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [_tvLogShower.textStorage appendAttributedString:attMsg];
            [_tvLogShower.textStorage addAttribute:NSForegroundColorAttributeName value:colorSet[logMessage.level] range:NSMakeRange(_tvLogShower.textStorage.length - attMsg.length, attMsg.length)];
            [_tvLogShower.textStorage addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Arial" size:10] range:NSMakeRange(_tvLogShower.textStorage.length - attMsg.length, attMsg.length)];
            
            NSError *err = nil;
            for(NSTextCheckingResult *rst in matches)
            {
                NSString *tailPattern = [NSString stringWithFormat:@"%@ \\^+[^\n]+", [logMessage.message substringWithRange:[rst rangeAtIndex:1]]];
                NSRegularExpression *tailRegex = [[NSRegularExpression alloc] initWithPattern:tailPattern options:0 error:&err];
                NSTextCheckingResult *tailRst = [tailRegex firstMatchInString:logMessage.message options:0 range:NSMakeRange(NSMaxRange(rst.range), logMessage.message.length-NSMaxRange(rst.range))];
                
                NSRange range = NSMakeRange(rst.range.location, NSMaxRange(tailRst.range)-rst.range.location);

                [_tvLogShower.textStorage addAttribute:NSForegroundColorAttributeName value:colorSet[MSG_ERROR] range:NSMakeRange(_tvLogShower.textStorage.length-attMsg.length+range.location, range.length)];
            }
            
            [_tvLogShower scrollRangeToVisible:NSMakeRange(_tvLogShower.string.length, 0)];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [_tvLogShower setString:@""];
        });
    }
}


-(void)refresh
{
    _ivResultSimple.image = [AppConfig config].imgGrayLed;
    _piPropressIndicator.doubleValue = 0;
    _tfItemCounter.stringValue = [NSString stringWithFormat:@"0/N"];
//    _btSimulate.hidden = ![AppConfig config].debugEnabled;
    
    [self resizeColumn];
    if(_normalSequenceTable.numberOfRows > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [_normalSequenceTable scrollRowToVisible:0];
        });
    }
}

- (void)resizeWithSimpleFrame:(NSRect)simpleFrame andNormalFrame:(NSRect)normalFrame andResultDisplayType:(DUT_RESULTDISPLAYTYPE)rdType
{
    _simpleInfoView.frame = NSMakeRect(NSMinX(simpleFrame), NSMinY(simpleFrame), NSWidth(simpleFrame), NSHeight(_simpleInfoView.frame));
    _normalInfoView.frame = NSMakeRect(0, 0, NSWidth(normalFrame), NSHeight(normalFrame));
    _resultDisplayType = rdType;
    
    [self refresh];
}


- (void)resizeColumn
{
    float visableWidth = _scrollView.contentSize.width;

    NSTableColumn *column = _normalSequenceTable.tableColumns[[_normalSequenceTable columnWithIdentifier:@"result"]];
    column.hidden = _resultDisplayType == DUT_RDT_IMAGE ? NO : YES;
    
    NSTableColumn *normalValueCol = _normalSequenceTable.tableColumns[[_normalSequenceTable columnWithIdentifier:@"value"]];
    NSTableColumn *failValueCol = _failItemTable.tableColumns[[_failItemTable columnWithIdentifier:@"value"]];
    float rstInc = (_resultDisplayType == DUT_RDT_IMAGE) ? 0 : -50;
    float debugInc = [AppConfig config].debugEnabled ? 10 : 0;
    float cellXSpace = _normalSequenceTable.intercellSpacing.width * (_resultDisplayType == DUT_RDT_IMAGE ? 6 : 5);
    normalValueCol.width = failValueCol.width = visableWidth - (630 + rstInc + debugInc + cellXSpace);
}

- (IBAction)changeEnabled:(NSButton *)sender
{
    self.enabled = sender.state;
}


-(void)updateItem:(TestItem *)item
{
    NSInteger row = [_normalSequenceTable rowForItem:item];
    if(row >= 0)
    {
//        dispatch_async(dispatch_get_main_queue(), ^(){

        [_normalSequenceTable reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _normalSequenceTable.numberOfColumns)]];
            
        // 背景色控制
        NSTableRowView *rowView = [_normalSequenceTable rowViewAtRow:row makeIfNecessary:NO];
        [self changeBackgroundColorOfRowView:rowView forItem:item atRow:row];
        
        NSInteger row = [_normalSequenceTable rowForItem:item];

        row = [_normalSequenceTable rowForItem:item];
            [_normalSequenceTable scrollRowToVisible:row];
//        });
    }
}


- (IBAction)changeItemState:(id)sender
{
    NSButton *ckBTN = (NSButton *)sender;
    NSRect cellRect = [ckBTN convertRect:ckBTN.frame toView:_normalSequenceTable];
    NSInteger row = [_normalSequenceTable rowsInRect:cellRect].location;
    JKTestItem *item = [_normalSequenceTable itemAtRow:row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_ITEM_STATECHANGED object:self userInfo:@{@"Item":item, @"State":[NSNumber numberWithBool:ckBTN.state]}];
}

- (void)itemStateChanged:(NSNotification *)notification
{
    TestItem *itemModel = [notification.userInfo objectForKey:@"Item"];
    NSInteger index = itemModel.index;
    BOOL enableState = [[notification.userInfo objectForKey:@"State"] boolValue];
//    id item = [self itemForID:index inSet:_sequence.items];
    id item = _sequence.items[index-1];
    
    if([AppConfig config].synchItemState4AllDUTs)
    {
        [item setEnabled:enableState];
    }
}

- (IBAction)enableAllItems:(id)sender
{
    BOOL enabled = YES;
    for(TestItem *item in _sequence.items)
    {
        [item setEnabled:enabled];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_ITEM_STATECHANGED object:self userInfo:@{@"Item":item, @"State":@(item.enabled)}];
    }
    
    [_normalSequenceTable reloadData];
}

- (IBAction)disableAllItems:(id)sender
{
    BOOL enabled = NO;
    for(TestItem *item in _sequence.items)
    {
        [item setEnabled:enabled];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_ITEM_STATECHANGED object:self userInfo:@{@"Item":item, @"State":@(item.enabled)}];
    }
    
    [_normalSequenceTable reloadData];
}

//static BOOL expandAllItems = NO;
//- (IBAction)expandAllItems:(id)sender
//{
//    expandAllItems = YES;
//    [_normalSequenceTable expandItem:nil expandChildren:YES];
//    expandAllItems = NO;
//    [_normalSequenceTable reloadData];
//}

//static BOOL collapseAllItems = NO;
//- (IBAction)collapseAllItems:(id)sender
//{
//    collapseAllItems = YES;
//    [_normalSequenceTable collapseItem:nil collapseChildren:YES];
//    collapseAllItems = NO;
//    [_normalSequenceTable reloadData];
//}

- (NSTableHeaderView *)createHeaderViewForTable:(NSTableView *)tableView
{
    NSTableHeaderView *thView = [[NSTableHeaderView alloc] initWithFrame:NSMakeRect(0, 0, tableView.frame.size.width, 25)];
    NSButton *cbBTN = [[NSButton alloc] init];
    [cbBTN setButtonType:NSSwitchButton];
    cbBTN.title = @"ID";
    [thView addSubview:cbBTN];
    tableView.headerView = thView;
    thView.tableView = tableView;
    
    return thView;
}

/*********   Item Source   **********/


-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSArray *dataSource = _sequence.items;
    if([outlineView.identifier isEqualTo:@"failList"])
    {
        dataSource = _failItemSet;
    }
    long childNumber = 0;
    if(!item)
    {
        childNumber =  dataSource.count;
    }
    
    return childNumber;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return NO;
}

//-(BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
//{
//    return [[item valueForKeyPath:@"subItems"] count] > 0 ;
//}

-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSArray *dataSource = _sequence.items;
    if([outlineView.identifier isEqualTo:@"failList"])
    {
        dataSource = _failItemSet;
    }

    id childItem = nil;
    if(!item)
    {
        childItem = dataSource[index];
    }
    return childItem;
}

/****   ^^^^^Item Source^^^^^   ****/

/********  Outline Delegate  ********/

-(NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(TestItem *)item
{
    if(tableColumn.identifier)
    {
        NSTableCellView *cellView = [outlineView makeViewWithIdentifier:tableColumn.identifier owner:self];
        TestItem *tItem = (TestItem *)item;
        
        if([tableColumn.identifier isEqualTo:@"index"])
        {
            //更新ID列尺寸设置
            tableColumn.minWidth = tableColumn.maxWidth = tableColumn.width = [AppConfig config].debugEnabled ? 60 : 50;
            for(NSControl *ctr in cellView.subviews)
            {
                if([ctr isKindOfClass:NSTextField.class])
                {
                    ctr.hidden = [outlineView.identifier isEqualTo:@"failList"] ? NO : [AppConfig config].debugEnabled;
                    ctr.stringValue = [@(item.index) description];
                    ctr.enabled = !item.enabled;
                }
                else
                {
                    ctr.hidden = !([AppConfig config].debugEnabled);
                    ((NSButton *)ctr).title = [@(item.index) description];
                    ((NSButton *)ctr).state = tItem.enabled;
                    ((NSButton *)ctr).enabled = ([AppConfig config].debugEnabled);
                }
            }
        }
        else if([tableColumn.identifier isEqualTo:@"result"])
        {
            if(_resultDisplayType == DUT_RDT_IMAGE)
            {
//                cellView.imageView.image = [itemRstLedDic objectForKey:[NSNumber numberWithInteger:tItem.testResult]];
            }
        }
        else if([tableColumn.identifier isEqualTo:@"cycleTime"])
        {
            NSString *format = [NSString stringWithFormat:@"%%.%dlf", tItem.cycleTime < 100 ? tItem.cycleTime < 10 ? tItem.cycleTime < 1 ? 3 : 2 : 1 : 0];
            NSString *ctString = tItem.cycleTime >=0 ? [NSString stringWithFormat:format, tItem.cycleTime] : @"";
            cellView.textField.stringValue = ctString;
        }
        else
        {
            NSString *value = [item valueForKeyPath:tableColumn.identifier];
            value = value ? value : @"";
            cellView.textField.stringValue = value;
            cellView.textField.toolTip = value;
        }
        
        if(cellView.textField)
        {//字体颜色设置
            if([tableColumn.identifier isEqualTo:@"index"])
            {
                cellView.textField.textColor = tItem.enabled ? [NSColor lightGrayColor] : [NSColor grayColor];
            }
            else
            {
                if(tItem.enabled)
                {
                    if([tableColumn.identifier isNotEqualTo:@"value"] || tItem.result == RST_NONE)
                    {
                        cellView.textField.textColor = [NSColor blackColor];
                    }
                    else
                    {
                        cellView.textField.textColor = tItem.result == RST_PASS ? [NSColor blueColor] : [NSColor redColor];
                    }
                }
                else
                {
                    cellView.textField.textColor = [NSColor darkGrayColor];
                }
            }
        }
//                cellView.textField.backgroundColor = _defaultColorOfRow;
        return cellView;
    }
    else
    {
        return nil;
    }
}

-(void)outlineView:(NSOutlineView *)outlineView didAddRowView:(nonnull NSTableRowView *)rowView forRow:(NSInteger)row
{
    TestItem *item = [outlineView itemAtRow:row];
    [self changeBackgroundColorOfRowView:rowView forItem:item atRow:row];
}

- (void)changeBackgroundColorOfRowView:(NSTableRowView *)rowView forItem:(TestItem *)item atRow:(NSInteger)row
{
    if([item.value containsString:kSKIPValueIdentifier])
    {
        rowView.backgroundColor = _disableColorOfRow;
    }
}


-(void)outlineViewSelectionDidChange:(NSNotification *)notification
{
//    NSOutlineView *outlineView = (NSOutlineView *)notification.object;
//    if(_selectedRow >= 0
//       && _testEngine.allItemSet.count > 0
//       && _selectedRow < outlineView.numberOfRows)
//    {
//        NSTableRowView *rowView = [outlineView rowViewAtRow:_selectedRow makeIfNecessary:YES];
//        JKTestItem *item = (JKTestItem *)[_ovItemView itemAtRow:_selectedRow];
//        [self changeBackgroundColorOfRowView:rowView forItem:item atRow:_selectedRow];
//    }else{};
//    
//    _selectedCol = outlineView.selectedColumn;
//    _selectedRow = outlineView.selectedRow;
//    if(_selectedRow >= 0  && _testEngine.allItemSet.count > 0)
//    {
//        NSTableRowView *rowView = [outlineView rowViewAtRow:_selectedRow makeIfNecessary:YES];
//        rowView.backgroundColor = _selectedColorOfRow;
//    }
}


/*****  ^^^^Outline Delegate^^^^ ****/

/*****  Menu Delegate  *****/
- (void)menuWillOpen:(NSMenu *)menu
{
    if([AppConfig config].debugEnabled && self.isTesting == NO)
    {
        _miTestSelectedItem.hidden      = NO;
        _miEnableAllItems.hidden        = NO;
        _miDisableAllItems.hidden       = NO;
    }
    else
    {
        _miEnableAllItems.hidden        = YES;
        _miDisableAllItems.hidden       = YES;
        _miTestSelectedItem.hidden      = YES;
    }
    
    _miExpandAllItems.hidden    = self.isTesting;
    _miCollapseAllItems.hidden  = self.isTesting;
}

- (void)menuDidClose:(NSMenu *)menu
{
}
/***** ^Menu Delegate^ *****/

@end
