//
//  DUTListView.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "DUTContainer.h"
#import "AppConfig.h"

#import "JKZMQObjC.h"
#import "ZMQPorts.h"
#import "RPCRequester.h"
#import "Subcriber.h"
#import "Protocol.h"


@interface DUTContainer ()<MessageHandlerProtocol>
{
    IBOutlet NSScrollView               *_scrollView;
    NSMutableArray<__kindof DUTView*>   *_dutVCArray;
    JKView                              *_dutViewContainer;
    IBOutlet NSSplitView                *_splitView;
    
    float       _dutWidth;
    float       _dutHeight;
    NSSize      _contentSize;
    int         _xMargin;
    int         _yMargin;
    int         _xSpace;
    int         _ySpace;
    BOOL        _showSimpleDUTView;
    
    NSString        *_scriptName;
    
    IBOutlet NSView             *_detailView;
    NSInteger                   _currentDUTIndex;
    BOOL                        _abortFlag;
    
    NSDictionary            *_currentSNSet;
    NSMutableDictionary     *_groupSNSets;
    NSMutableSet            *_dutSetForLoopStatistics;
    
    NSArray<NSNumber *>     *_dutStates;
    
    ///RPC
    RPCRequester        *_requesterToSM;
    Subcriber           *_subcriberOfSM;
}

@end

@implementation DUTContainer

static dispatch_once_t token;
//static NSMutableSet        *_dutSetForLoopStatistaic;
-(void)awakeFromNib
{
    dispatch_once(&token, ^(){
        _dutVCArray = [[NSMutableArray alloc] init];
        _dutViewContainer = [[JKView alloc] initWithFrame:NSMakeRect(0, 0, _contentSize.width, _contentSize.height)];
        _currentDUTIndex = 0;
        _loopTimes = 0;
        
        _dutSetForLoopStatistics = [NSMutableSet set];
        _groupSNSets = [NSMutableDictionary dictionary];
        _dutStates = @[@1, @1, @0, @0, @0, @0, @0, @0];
        
        ///RPC
        // 初始化 GUI Requester
        NSString *identifier    = @"MAIN_GUI";
        _requesterToSM      = [[RPCRequester alloc] initWithIdentifier:identifier
                                                              endpoint:[NSString stringWithFormat:@"tcp://localhost:%ld", [ZMQPorts sharedZMQPorts].STATEMACHINE_PORT]];
        
        // 初始化 StateMachine 的 Subcriber
        _subcriberOfSM      = [[Subcriber alloc] initWithIdentifier:identifier
                                                           endpoint:[NSString stringWithFormat:@"tcp://localhost:%ld", [ZMQPorts sharedZMQPorts].STATEMACHINE_PUB]];
        [_subcriberOfSM subcribe4Caller:self];
        
        [NSThread detachNewThreadWithBlock:^(){
            DUTView *dv = nil;
            NSArray *colorSet = @[[NSColor yellowColor], [NSColor blueColor]];
            __block BOOL colorFlag = YES;
            while([NSThread mainThread].isExecuting)
            {
                if(_currentDUTIndex>=0 && _currentDUTIndex<_dutVCArray.count)
                {
                    dv = _dutVCArray[_currentDUTIndex];
                    dispatch_sync(dispatch_get_main_queue(), ^(){
//                        dv.simpleView.backgroundColor = [NSColor controlColor];
//                        [dv.simpleView setNeedsDisplay:YES];
                    });
                    colorFlag = !colorFlag;
                }
                [NSThread sleepForTimeInterval:1];
            }
        }];
    });
}

- (id)handleMessage:(NSArray *)msgData
{
    return @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewDidAppear
{
    int idx = 0;
    
    [self resizeView];
    for(DUTView *dv in _dutVCArray)
    {
        [dv refresh];
        dv.enabled = [_dutStates[idx++] integerValue];
    }
}

- (NSArray<__kindof NSNumber*> *)enabledSites
{
    NSMutableArray *set = [[NSMutableArray alloc] init];
    for(DUTView *dv in _dutVCArray)
    {
        if(dv.enabled)
        {
            
            [set addObject:@(dv.site)];
        }
    }
    
    return [set copy];
}

- (NSArray<__kindof NSNumber*> *)availableDUTIndexSet
{
    NSMutableArray *set = [[NSMutableArray alloc] init];
    int index = 1;
    for(DUTView *dv in _dutVCArray)
    {
        if(dv.isTesting == NO)
        {
            [set addObject:@(index)];
        }
        index++;
    }
    
    return [set copy];
}

- (void)resizeView
{
    dispatch_block_t block = ^(){
        [self recalculateSize];
        
        int dutCount = [AppConfig config].dutCount;
        BOOL dutCountChanged = dutCount != _dutVCArray.count;
        
        if(dutCountChanged)
        {
            for(DUTView *dv in _dutVCArray)
            {
                [dv removeObserver:self forKeyPath:@"testResult"];
                [dv removeObserver:self forKeyPath:@"enabled"];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:NC_DUT_SELECTED object:dv];
                [[NSNotificationCenter defaultCenter] removeObserver:dv name:NC_ITEM_STATECHANGED object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:NC_DUT_STARTTEST object:dv];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:NC_DUT_ENDTEST object:dv];
                [dv close];
            }
            [_dutVCArray removeAllObjects];
        }
        
        _dutViewContainer = [[JKView alloc] initWithFrame:NSMakeRect(0, 0, _contentSize.width, _contentSize.height)];
        for(int i=0; i<dutCount; i++)
        {
            int colIdx = i % 2;
            int rowIdx = i / 2;
            float xPos = (_dutWidth + _xSpace) * colIdx + _xMargin;
            if([AppConfig config].orderModeInRow != 0)
            {
                xPos = _contentSize.width - _dutWidth*(colIdx+1) - _xSpace*colIdx - _xMargin;
            }
            float yPos = _contentSize.height - _dutHeight * (rowIdx+1) - _ySpace * rowIdx - _yMargin;
            if([AppConfig config].orderModeInColumn != 0)
            {
                yPos = (_dutHeight + _ySpace) * rowIdx + _yMargin;
            }
            
    //        float yPos = _dutHeight * i + _ySpace * i;
            NSRect dutFrame = NSMakeRect(xPos, yPos, _dutWidth, _dutHeight);
            
            if(dutCountChanged)
            {
                DUTView *dutView = [[DUTView alloc] initForSite:i];
                [dutView addObserver:self forKeyPath:@"testResult" options:NSKeyValueObservingOptionNew context:nil];
                [dutView addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
                [_dutVCArray addObject:dutView];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedViewChanged:) name:NC_DUT_SELECTED object:dutView];
                [[NSNotificationCenter defaultCenter] addObserver:dutView selector:@selector(itemStateChanged:) name:NC_ITEM_STATECHANGED object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testStart:) name:NC_DUT_STARTTEST object:dutView];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testEnd:) name:NC_DUT_ENDTEST object:dutView];
            }
            
            [_dutVCArray[i] resizeWithSimpleFrame:dutFrame
                             andNormalFrame:_detailView.frame
                            andResultDisplayType:(DUT_RESULTDISPLAYTYPE)[AppConfig config].displayResultByBackgoundColor];
            
            [_dutViewContainer addSubview:_dutVCArray[i].simpleView];
        }
        _dutViewContainer.backgroundColor = [NSColor brownColor];
        
        _scrollView.documentView = _dutViewContainer;
        
        [_scrollView.documentView scrollPoint:NSMakePoint(0, NSMaxY([[_scrollView documentView] frame])-NSHeight([[_scrollView contentView] bounds]))];
        
        _scriptName = [AppConfig config].testPlanName;
        
        [self selectDUTAtSite:_currentDUTIndex];
    };
    
    if(NSThread.isMainThread)
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

-(void)recalculateSize
{
    NSSize visableSize = _scrollView.visibleRect.size;
    int dutCount = [AppConfig config].dutCount;
    _xMargin    = [AppConfig config].xMargin;
    _yMargin    = [AppConfig config].yMargin;
    _xSpace     = [AppConfig config].xSpaceBetweenDUTs;
    _ySpace     = [AppConfig config].ySpaceBetweenDUTs;
    
    _showSimpleDUTView = NO;
    float contentWidth = visableSize.width;
    contentWidth = contentWidth-2;
    float vScrollerWidth = _scrollView.verticalScroller.hidden ? 0 : 0;//NSWidth(_scrollView.verticalScroller.frame);
    _dutWidth = ([AppConfig config].dutCount > 1 ? (contentWidth -_xSpace - _xMargin*2 - vScrollerWidth)/2 : contentWidth-_xMargin*2 - vScrollerWidth);
    _dutHeight = [[DUTView alloc] init].simpleSize.height;
    float rowCount = dutCount / (dutCount>1?2:1);
    float contentHeight = _dutHeight * rowCount + _ySpace * (rowCount-1) + _yMargin*2;
    float hScrollerHeight = _scrollView.horizontalScroller.hidden ? 0 : 0;//_scrollView.horizontalScroller.frame.size.height;
    contentHeight = contentHeight + hScrollerHeight;
    
    _contentSize = NSMakeSize(contentWidth, contentHeight);
    
    if(rowCount > 4)
    {
        [_splitView setPosition:_dutHeight*4 + _ySpace*3 + _yMargin*2 ofDividerAtIndex:0];
    }
    else
    {
        [_splitView setPosition:_contentSize.height+2 ofDividerAtIndex:0];
    }
}

-(void)selectDUTAtSite:(NSInteger)site
{
    NSInteger index = site >=0 && site < _dutViewContainer.subviews.count ? site : 0;
    [_dutVCArray[index] mouseDown:[[NSEvent alloc] init]];
}


/******     Notification     *******/
-(void)selectedViewChanged:(NSNotification *)notification
{
    DUTView *dutView = notification.object;
    for(int i =0; i<_detailView.subviews.count; i++)
    {
        [_detailView.subviews[i] removeFromSuperview];
    }
    for(JKView *view in _dutViewContainer.subviews)
    {
        view.backgroundColor = [NSColor gridColor];
    }
    
    dutView.normalView.frame = NSMakeRect(0, 0, NSWidth(_detailView.frame), NSHeight(_detailView.frame));
    [_detailView addSubview:dutView.normalView];
    dutView.simpleView.backgroundColor = [NSColor blueColor];
    
    [_scrollView setNeedsDisplay:YES];

    _currentDUTIndex = dutView.site;
}

- (void)testStart:(NSNotification *)notification
{
    
}

- (void)testEnd:(NSNotification *)notification
{
    
}
/****** ^^^^  Notification  ^^^^ ******/

- (void)disableControl
{
    for(DUTView *dv in _dutVCArray)
    {
        dv.controllable = NO;
    }
}

- (void)enableControl
{
    for(DUTView *dv in _dutVCArray)
    {
        dv.controllable = YES;
    }
}

- (void)abortTest
{
    _abortFlag = YES;
    for(DUTView *dv in _dutVCArray)
    {
        [dv abortTest];
    }
}

- (void)runWithSnSet:(NSDictionary *)snDic
{
    resetFlag = YES;
    _abortFlag = NO;
    [_dutSetForLoopStatistics removeAllObjects];
    
    int gIdx = 0;
    for(NSArray *dutIdxSet in [AppConfig config].ChannelGroup)
    {
        if([dutIdxSet containsObject:snDic.allKeys[0]])
        {
            break;
        }
        gIdx++;
    }
    
    [_groupSNSets setObject:snDic forKey:[NSNumber numberWithInteger:gIdx]];
    
//    NSLog(@"SNCount: %ld", snDic.count);
    
    _currentSNSet = [snDic mutableCopy];
    for(NSNumber *idx in snDic.allKeys)
    {
        [_dutVCArray[idx.integerValue] runWithSN:[snDic objectForKey:idx]];
    }
}

static BOOL resetFlag = YES;
- (void)setSerialNumber:(NSString *)serialNumber forSite :(NSInteger)site
{
    if(resetFlag)
    {
        [self resetAllDUTViews];
        resetFlag = NO;
    }
    
    [_dutVCArray[site] setSerialNumber:serialNumber];
}

- (void)resetAllDUTViews
{
    for(DUTView *dv in _dutVCArray)
    {
        [dv refresh];
    }
}

static NSSet     *dutSetForLoopStatistic;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualTo:@"testResult"])
    {
        DUTView *dv = (DUTView *)object;
        if(dv)
        {
            JKTRESULT rst = (JKTRESULT)[[change valueForKey:@"new"] intValue];
            if(rst == TR_PASS)
            {
                self.passDUTCount++;
            }
            self.testedDUTCount++;
            [_dutSetForLoopStatistics addObject:dv];
            if(_dutSetForLoopStatistics.count == self.enabledSites.count)
            {
                [_dutSetForLoopStatistics removeAllObjects];
                self.loopTimes++;       //this operation will notice the main window
                if(self.loopTimes == [AppConfig config].loopTestTimes
                   || _abortFlag
                   || dv.manualTestFlag)
                {//reset
                    resetFlag = YES;
                    _loopTimes = 0;
                }
                else
                {//loop test
                    int idx = 0;
                    for(NSArray *dutIdxSet in [AppConfig config].ChannelGroup)
                    {
                        for(NSNumber *dutIdx in self.enabledSites)
                        {
                            if([dutIdxSet containsObject:dutIdx])
                            {
                                NSNumber *gIdx = [NSNumber numberWithInteger:idx];
                                [[[NSThread alloc] initWithTarget:self selector:@selector(loopTestForGroup:) object:gIdx] start];
                                break;
                            }
                        }
                        idx++;
                    }

                }
            }
        }
    }
    else if([keyPath isEqualTo:@"enabled"])
    {
        self.enabledChangeFlag = 0;
        for(DUTView *dv in _dutVCArray)
        {
            [dv refresh];
        }
        [self selectDUTAtSite:[self.enabledSites firstObject].intValue];
    }
}

- (void)loopTestForGroup:(NSNumber *)groupIndex
{
    [NSThread sleepForTimeInterval:[AppConfig config].loopInterval];
    [[[NSThread alloc] initWithTarget:self selector:@selector(runWithSnSet:) object:[_groupSNSets objectForKey:groupIndex]] start];
}


-(void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize
{
    int dutCount = [AppConfig config].dutCount;
    if(dutCount > 4)
    {
        [_splitView setPosition:_dutHeight * 4 + _ySpace * 4 ofDividerAtIndex:0];
    }
    else
    {
        [_splitView setPosition:_contentSize.height ofDividerAtIndex:0];
    }
}

@end
