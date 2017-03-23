//
//  Spec.h
//  FCT
//
//  Created by Jack.MT on 16/7/5.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _JKNoLimit
static const double     JKNoLimit = 999999999999999;
#endif

static const NSString   *PASS_VALUE     = @"YES";
static const NSString   *FAIL_VALUE     = @"NO";

@interface JKSpec : NSObject

///////
/**
  *  a special function for checking value
  *  the format must like "(NSString *)funcationName:(NSString *)value withParamDic:(NSDictionary *)paramDic"
 */
@property(readonly) NSString        *specFunction;
/**
 *function arguments for checking value.
 *In function,the values of all funcArgs can be got by call [JKBaseDevice argForKey:(NSString *) inParamDic:(NSDictionary *)paramDic.
 */
@property(readonly) NSDictionary          *funcArgs;

////////////
/**
    pattern of expected value; priority lower than specFunction.
    if it contains string '<%bufferName>', the string will be replaced by the value with key bufferName in the buffer of AppConfig*/
@property(readonly) NSString        *pattern;
/**
 For YES, if the value matches the pattern, the result is FAIL*/
@property(readonly) BOOL            reverseFlag;

///////////////////
/**
    the expect value is asn Absolute Value; priority lower than pattern;*/
@property(readonly) NSString        *absValue;

////////////////////////
/**
 lower limit for digit value; priority lower than pattern;*/
@property(readonly) double          lowerLimit;
/**
 upper limit for digit value; priority lower than pattern;*/
@property(readonly) double          upperLimit;
@property(readonly) NSString        *unit;

- (instancetype)initWithParamDic:(NSDictionary *)paramDic;

/**
 check the testvalue of item */
- (BOOL)checkValue:(NSString *) value withParamDic:(NSDictionary *)paramDic;

@end
