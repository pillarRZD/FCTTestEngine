//
//  AppConfig.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <JKFramework/JKFramework.h>

@interface AppConfig : JKAppConfig

+(instancetype)config;

@property(nonatomic) int        dutCount;
@property(nonatomic) NSArray    *ChannelGroup;

/// properties for layout
@property(nonatomic) int        xMargin;
@property(nonatomic) int        yMargin;
@property(nonatomic) int        xSpaceBetweenDUTs;
@property(nonatomic) int        ySpaceBetweenDUTs;
//@property(nonatomic) BOOL       autoShowSimpleDUTView;
@property(nonatomic) BOOL       displayResultByBackgoundColor;
@property(nonatomic) int        orderPriority;  //0 for row, 1 for column, default 0
@property(nonatomic) int        orderModeInRow; //0 means that the views will be layout from left to right and non-0 means from right to left
@property(nonatomic) int        orderModeInColumn;  //0 means that the views will be layout from top to bottom and non-0 means from bottom to top
@property(nonatomic) BOOL       synchItemState4AllDUTs;

@property(nonatomic) BOOL       debugEnabled;

@property(nonatomic) BOOL       startTestByButton;

@property(nonatomic) NSInteger  snLength;
/**
 无文件后缀则默认是plist文件*/
@property(nonatomic) NSString   *testPlanName;

@property(nonatomic) NSString   *sequencerPath;

@property(nonatomic) BOOL         loopTestEnabled;
@property(nonatomic) NSInteger    loopTestTimes;    //default(1)
@property(nonatomic) double       loopInterval;     //default(2.0)

@property(nonatomic) NSString     *userPWD;

@property(nonatomic) BOOL         continueOnFail;

@property(nonatomic) NSDictionary   *functionMap;


/// test switch
@property(nonatomic) BOOL       pdcaEnabled;

@property(nonatomic, readonly) NSImage      *imgPass;
@property(nonatomic, readonly) NSImage      *imgFail;
@property(nonatomic, readonly) NSImage      *imgTesting;
@property(nonatomic, readonly) NSImage      *imgCommErr;
@property(nonatomic, readonly) NSImage      *imgFatalErr;
@property(nonatomic, readonly) NSImage      *imgAbort;
@property(nonatomic, readonly) NSImage      *imgNone;
@property(nonatomic, readonly) NSImage      *imgRedLed;
@property(nonatomic, readonly) NSImage      *imgYellowLed;
@property(nonatomic, readonly) NSImage      *imgGreenLed;
@property(nonatomic, readonly) NSImage      *imgGrayLed;

@property(nonatomic, readonly) NSLock       *globalLock;

- (BOOL)needCheckStateForDeviceCategory:(NSString *)devCategory;
@end
