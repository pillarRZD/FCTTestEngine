//
//  Operation.h
//  FCT
//
//  Created by Jack.MT on 16/7/5.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKCommAction.h"
#import "JKValueProcessor.h"
#import "JKSpec.h"
#import "JKTestMacro.h"
#import "JKTestControl.h"

//#define SPEC_KEY_PATH_PATTERN           @"Pattern"
//#define SPEC_KEY_PATH_RANGE             @"Range"

@interface JKOperation : NSObject

@property(readonly) NSString                  *name;

@property(readonly) NSString                  *device;
@property(readonly) JKCommAction              *commAction;
@property(readonly) JKValueProcessor          *valueProcessor;
@property(readonly) JKSpec                    *spec;

@property JKTestControl             *testControl;

@property(copy) NSString            *orgValue;
@property(copy) NSString            *processedValue;
@property JKTRESULT                 opResult;
@property double                    cycleTime;

@property(readonly) NSDictionary    *valueReplacement;       //当结果为PASS／FAIL时的替代结果显示字符串

@property(readonly) NSString        *bufferName;

@property(nonatomic, readonly) NSDate                   *startTime;
@property(nonatomic, readonly) NSDate                   *endTime;

- (instancetype)initWithParamDic:(NSDictionary *) paramDic;
- (void)reset;

- (JKTRESULT)runWithParamDic:(NSDictionary *)paramDic;

@end
