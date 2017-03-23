//
//  AppConfig.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig
{
//    NSImage     *_imgPass;
//    NSImage     *_imgFail;
//    NSImage     *_imgTesting;
//    NSImage     *_imgNone;
}

static dispatch_once_t initToken;
- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        dispatch_once(&initToken, ^(){
            _imgPass        = [NSImage imageNamed:@"pass.png"];
            _imgFail        = [NSImage imageNamed:@"fail.png"];
            _imgTesting     = [NSImage imageNamed:@"testing.png"];
            _imgCommErr     = [NSImage imageNamed:@"comm_error.png"];
            _imgFatalErr    = [NSImage imageNamed:@"fatal_error.png"];
            _imgAbort       = [NSImage imageNamed:@"abort.png"];
            _imgNone        = [NSImage imageNamed:@"none.png"];
            _imgRedLed      = [NSImage imageNamed:@"redLed.png"];
            _imgYellowLed   = [NSImage imageNamed:@"yellowLed.png"];
            _imgGreenLed    = [NSImage imageNamed:@"greenLed.png"];
            _imgGrayLed     = [NSImage imageNamed:@"grayLed.png"];
            
            _globalLock     = [[NSLock alloc] init];
        });
    }
    
    return self;
}


static AppConfig *config;
static dispatch_once_t token;

+ (instancetype)config
{
    if(config)
    {
        return config;
    }
    else
    {
        return [[AppConfig alloc] init];
    }
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    dispatch_once(&token, ^(){
        config = [[super allocWithZone:zone] init];
    });
    
    return config;
}

- (instancetype)copy
{
    return self;
}

- (int)dutCount
{
    return [[_infoDictionary valueForKeyPath:@"General.CountOfDUT"] intValue];
}

- (void)setDutCount:(int)dutCount
{
    [_infoDictionary setValue:[NSNumber numberWithInt:dutCount] forKeyPath:@"General.CountOfDUT"];
}

- (NSArray *)ChannelGroup
{
    NSArray *groups = (NSArray *)[_infoDictionary valueForKeyPath:@"General.ChannelGroup"];
    if(groups == nil)
    {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for(int i=0; i<self.dutCount; i++)
        {
            [tmpArr addObject:[NSNumber numberWithInt:i]];
        }
        groups = [tmpArr copy];
    }
    
    return groups;
}

- (int)xMargin
{
    int margin = [[_infoDictionary valueForKeyPath:@"Layout.XMargin"] intValue];
    margin = margin > 0 ? margin : 0;
    return margin;
}

- (void)setXMargin:(int)xMargin
{
    if(xMargin > 0)
    {
        [_infoDictionary setValue:[NSNumber numberWithInt:xMargin] forKeyPath:@"Layout.XMargin"];
    }
}

- (int)yMargin
{
    int margin = [[_infoDictionary valueForKeyPath:@"Layout.YMargin"] intValue];
    margin = margin > 0 ? margin : 0;
    return margin;
}

- (void)setYMargin:(int)yMargin
{
    if(yMargin > 0)
    {
        [_infoDictionary setValue:[NSNumber numberWithInt:yMargin] forKeyPath:@"Layout.YMargin"];
    }
}

- (int)ySpaceBetweenDUTs
{
    int space = [[_infoDictionary valueForKeyPath:@"Layout.YSpaceBetweenDUTs"] intValue];
    space = space > 0 ? space : 0;
    return space;
}

- (void)setYSpaceBetweenDUTs:(int)ySpaceBetweenDUTs
{
    [_infoDictionary setValue:[NSNumber numberWithInt:ySpaceBetweenDUTs] forKeyPath:@"Layout.YSpaceBetweenDUTs"];
}

- (int)xSpaceBetweenDUTs
{
    int space = [[_infoDictionary valueForKeyPath:@"Layout.XSpaceBetweenDUTs"] intValue];
    space = space > 0 ? space : 0;
    return space;
}

- (void)setXSpaceBetweenDUTs:(int)xSpaceBetweenDUTs
{
    if(xSpaceBetweenDUTs > 0)
    {
        [_infoDictionary setValue:[NSNumber numberWithInt:xSpaceBetweenDUTs] forKeyPath:@"Layout.XSpaceBetweenDUTs"];
    }
}

- (BOOL)allDUTVisable
{
    return [[_infoDictionary valueForKeyPath:@"Layout.AllDUTVisable"] boolValue];
}

- (void)setAllDUTVisable:(BOOL)allDUTVisable
{
    [_infoDictionary setValue:[NSNumber numberWithBool:allDUTVisable] forKeyPath:@"Layout.AllDUTVisable"];
}

- (int)orderPriority
{
    return [[_infoDictionary valueForKeyPath:@"Layout.OrderPriority"] intValue];
}

- (void)setOrderPriority:(int)orderPriority
{
    if(orderPriority > 0)
    {
        [_infoDictionary setValue:[NSNumber numberWithInteger:orderPriority] forKeyPath:@"Layout.OrderPriority"];
    }
}

- (int)orderModeInRow
{
    int mode = [[_infoDictionary valueForKeyPath:@"Layout.OrderModeInRow"] intValue];
    mode = mode == 0 ? 0 : 1;
    return mode;
}

- (void)setOrderModeInRow:(int)orderInRow
{
    if(orderInRow>=0)
    {
        [_infoDictionary setValue:[NSNumber numberWithInt:orderInRow] forKeyPath:@"Layout.OrderModeInRow"];
    }
}

- (int)orderModeInColumn
{
    int mode = [[_infoDictionary valueForKeyPath:@"Layout.OrderModeInColumn"] intValue];
    mode = mode == 0 ? 0 : 1;
    return mode;
}

- (void)setOrderModeInColumn:(int)orderInColumn
{
    if(orderInColumn>=0)
    {
        [_infoDictionary setValue:[NSNumber numberWithInt:orderInColumn] forKeyPath:@"Layout.OrderModeInColumn"];
    }
}

//-(BOOL)autoShowSimpleDUTView
//{
//    return [[_infoDictionary valueForKeyPath:@"Layout.AutoShowSimpleDUTView"] boolValue];
//}

- (void)setAutoShowSimpleDUTView:(BOOL)autoShowSimpleDUTView
{
    [_infoDictionary setValue:[NSNumber numberWithBool:autoShowSimpleDUTView] forKeyPath:@"Layout.AutoShowSimpleDUTView"];
}

- (BOOL)displayResultByBackgoundColor
{
    return [[_infoDictionary valueForKeyPath:@"Layout.DisplayResultByBackgroundColor"] boolValue];
}

- (void)setDisplayResultByBackgoundColor:(BOOL)displayResultByBackgoundColor
{
    [_infoDictionary setValue:[NSNumber numberWithBool:displayResultByBackgoundColor] forKeyPath:@"Layout.DisplayResultByBackgroundColor"];
}

- (BOOL)synchItemState4AllDUTs
{
    return [[_infoDictionary valueForKeyPath:@"Layout.SynchItemState4AllDUTs"] boolValue];
}

- (void)setSynchItemState4AllDUTs:(BOOL)synchItemState4AllDUTs
{
    [_infoDictionary setValue:[NSNumber numberWithBool:synchItemState4AllDUTs] forKeyPath:@"Layout.SynchItemState4AllDUTs"];
}

- (BOOL)debugEnabled
{
    return [[_infoDictionary valueForKeyPath:@"General.DebugEnabled"] boolValue];
}

- (void)setDebugEnabled:(BOOL)dubugEnabled
{
    [_infoDictionary setValue:[NSNumber numberWithBool:dubugEnabled] forKeyPath:@"General.DebugEnabled"];
}

- (BOOL)startTestByButton
{
    return [[_infoDictionary valueForKeyPath:@"General.StartTestByButton"] boolValue];
}

- (void)setStartTestByButton:(BOOL)startTestByButton
{
    [_infoDictionary setValue:[NSNumber numberWithBool:startTestByButton] forKeyPath:@"General.StartTestByButton"];
}

- (BOOL)pdcaEnabled
{
    return [[_infoDictionary valueForKeyPath:@"General.PDCAEnabled"] boolValue];
}

- (void)setPdcaEnabled:(BOOL)pdcaEnabled
{
    [_infoDictionary setValue:[NSNumber numberWithBool:pdcaEnabled] forKeyPath:@"General.PDCAEnabled"];
}

- (NSString *)testPlanName
{
    NSString *name = [_infoDictionary valueForKeyPath:@"General.TestPlanName"];
    if([name pathExtension] == nil || [[name pathExtension] isEqualTo:@""])
    {
        name = [name stringByAppendingPathExtension:@"csv"];
    }

    return name;
}

- (void)setTestPlanName:(NSString *)testPlanName
{
    [_infoDictionary setValue:testPlanName ? testPlanName : @"" forKeyPath:@"General.TestPlanName"];
}

- (NSString *)sequencerPath
{
    NSString *path = [_infoDictionary valueForKeyPath:@"General.SequencerPath"];
    if([path pathExtension] == nil || [[path pathExtension] isEqualTo:@""])
    {
        path = [path stringByAppendingPathExtension:@"py"];
    }
    return path;
}

- (void)setSequencerPath:(NSString *)sequencerPath
{
    [_infoDictionary setValue:sequencerPath ? sequencerPath : @"" forKeyPath:@"General.SequencerPath"];
}

- (NSString *)userPWD
{
    NSString *pwd = [_infoDictionary valueForKeyPath:@"General.UserPWD"];
    pwd = pwd ?: @"";
    return pwd;
}

- (void)setUserPWD:(NSString *)userPWD
{
    [_infoDictionary setValue:userPWD ? userPWD : @"" forKeyPath:@"General.SequencerPath"];
}

- (BOOL)continueOnFail
{
    return [[_infoDictionary valueForKeyPath:@"General.ContinueOnFail"] boolValue];
}

- (void)setContinueOnFail:(BOOL)continueOnFail
{
    [_infoDictionary setValue:@(continueOnFail) forKeyPath:@"General.ContinueOnFail"];
}

- (NSDictionary *)functionMap
{
    return [_infoDictionary valueForKeyPath:@"General.FunctionMap"];
}

- (void)setFunctionMap:(NSDictionary *)functionMap
{
    [_infoDictionary setValue:functionMap forKeyPath:@"General.FunctionMap"];
}

- (NSInteger)snLength
{
    NSInteger length = [[_infoDictionary valueForKeyPath:@"General.SNLength"] integerValue];
    length = length > 0 ? length : 12;
    return length;
}

- (void)setSnLength:(NSInteger)snLength
{
    if(snLength > 0)
    {
        [_infoDictionary setValue:[NSNumber numberWithInteger:snLength] forKeyPath:@"General.SNLength"];
    }
}

- (BOOL)loopTestEnabled
{
    return [[_infoDictionary valueForKeyPath:@"LoopTest.Enabled"] boolValue];
}

- (void)setLoopTestEnabled:(BOOL)loopTestEnabled
{
    [_infoDictionary setValue:[NSNumber numberWithBool:loopTestEnabled] forKeyPath:@"LoopTest.Enabled"];
}

- (NSInteger)loopTestTimes
{
    NSNumber *timesObj = [_infoDictionary valueForKeyPath:@"LoopTest.Times"];
    NSInteger times = timesObj && ([timesObj integerValue] > 0) && self.loopTestEnabled  ? [timesObj integerValue] : 1;
    return times;
}

- (void)setLoopTestTimes:(NSInteger)loopTestTimes
{
    if(loopTestTimes > 0)
    {
        [_infoDictionary setValue:[NSNumber numberWithInteger:loopTestTimes] forKeyPath:@"LoopTest.Times"];
    }
}

- (double)loopInterval
{
    NSNumber *intervalObj = [_infoDictionary valueForKeyPath:@"LoopTest.Interval"];
    double interval = intervalObj && ([intervalObj doubleValue] > 0) ? [intervalObj doubleValue] : 2;
    return interval;
}

- (void)setLoopInterval:(double)loopInterval
{
    if(loopInterval > 0)
    {
        NSNumber *intervalObj = [NSNumber numberWithDouble:loopInterval];
        [_infoDictionary setValue:intervalObj forKeyPath:@"LoopTest.Interval"];
    }
}

- (BOOL)needCheckStateForDeviceCategory:(NSString *)devCategory
{
    BOOL flag = [[_infoDictionary valueForKeyPath:[NSString stringWithFormat:@"Devices.%@.CheckFlag",devCategory]] boolValue];
    return flag;
}

@end
