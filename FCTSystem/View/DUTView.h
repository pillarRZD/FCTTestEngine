//
//  DUTView.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JKFramework/JKFramework.h>
#import "TestEngine.h"

typedef NS_ENUM(NSInteger, DUT_RESULTDISPLAYTYPE)
{
    DUT_RDT_IMAGE,
    DUT_RDT_BACKGROUND,
    DUT_RDT_COMPOSITE
};

static NSString *NC_DUT_SELECTED                = @"dutSelected";
static NSString *NC_DUT_ACTIVITED               = @"dutActivited";
static NSString *NC_DUT_STARTTEST               = @"dut_start_test";
static NSString *NC_DUT_ENDTEST                 = @"dut_end_test";
static NSString *NC_ITEM_STATECHANGED           = @"itemStateChanged";

@interface DUTView : NSViewController<NSOutlineViewDataSource, NSOutlineViewDelegate, NSMenuDelegate, JKTestObserverDelegate>

/**
 0-base */
- (instancetype)initForSite:(NSInteger)site;
//- (instancetype)initWithFrame:(NSRect)frameRect;
//- (instancetype)initWithFrame:(NSRect)frameRect andResultDisplayType:(DUT_RESULTDISPLAYTYPE)rdType;

- (void)refresh;

- (void)runWithSN:(NSString *)serialNumber;
- (void)setSerialNumber:(NSString *) serialNumber;
- (void)abortTest;

-(void)close;

- (void)resizeWithSimpleFrame:(NSRect)simpleFrame andNormalFrame:(NSRect)normalFrame andResultDisplayType:(DUT_RESULTDISPLAYTYPE)rdType;

-(void)showMessage:(JKLogMessage *)logMessage;

//-(void)startObserver

// 0-based
@property(nonatomic, readonly) NSInteger        site;

@property(nonatomic, readonly) NSView           *visableView;
@property(nonatomic, readonly) JKView           *simpleView;
@property(nonatomic, readonly) JKView           *normalView;

//@property(readonly) TestEngine                  *refTestEngine;

@property(nonatomic) NSRect                     frame;
@property(nonatomic, readonly) NSSize           normalSize;
@property(nonatomic, readonly) NSSize           simpleSize;

@property(nonatomic) BOOL                       enabled;
@property(nonatomic) BOOL                       controllable;

@property(readonly) BOOL                        manualTestFlag;

@property(nonatomic) DUT_RESULTDISPLAYTYPE      resultDisplayType;
@property(nonatomic) BOOL                       showSimpleView;

@property(readonly) BOOL                        isTesting;

@property TEST_RESULT      testResult;


- (void)itemStateChanged:(NSNotification *)notification;

@end
