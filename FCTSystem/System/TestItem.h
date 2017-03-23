//
//  TestItem.h
//  FCT(N121)
//
//  Created by Jack.MT on 2017/3/17.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kGROUP_KEY              @"GROUP"
#define kTID_KEY                @"TID"
#define kDESCRIPTION_KEY        @"DESCRIPTION"

#define kLOW_KEY                @"LOW"
#define kHIGH_KEY               @"HIGH"
#define kUNIT_KEY               @"UNIT"

/** Test Result */
typedef NS_ENUM(NSInteger, TEST_RESULT)
{
    RST_FAIL,
    RST_PASS,
    RST_TESTING,
    RST_NONE = NSIntegerMax
};


@interface TestItem : NSObject

- (instancetype)initWithConfig:(NSDictionary *)config;

@property NSInteger         index;

@property NSString          *group;
@property NSString          *tid;
@property NSString          *desc;

@property NSString          *low;
@property NSString          *high;
@property NSString          *unit;

@property NSString          *value;
@property TEST_RESULT       result;

@property BOOL              enabled;
@property double            cycleTime;

@end
