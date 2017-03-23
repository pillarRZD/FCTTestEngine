//
//  DUTController.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JKFramework/JKFramework.h>
#import "TestItem.h"


#define kManualTestStartNotification      @"ManualTestStart"
#define kManualTestFinishNotification     @"ManualTestFinish"

@interface TestEngine : NSObject

/**
 0-based*/
- (instancetype)initForSite:(NSInteger)site;

- (void)close;

@property(readonly) double      testTime;

@end
