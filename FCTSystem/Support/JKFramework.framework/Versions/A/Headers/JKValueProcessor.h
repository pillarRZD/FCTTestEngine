//
//  ValueProcessor.h
//  Test
//
//  Created by Jack.MT on 16/7/6.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _JKNoValue
static const double     JKNoValue = 999999999999999;
#endif


@interface JKValueProcessor : NSObject

/******   Clip Control    ******/
////////
/**
 *function for processing value.
 *the format must like "(NSString *)funcationName:(NSString *)value withParamDic:(NSDictionary *)paramDic"
 */
@property(readonly) NSString            *function;
/**
 *function arguments for processing value.
 *In function,the values of all funcArgs can be got by call [JKBaseDevice argForKey:(NSString *) inParamDic:(NSDictionary *)paramDic.
 */
@property(readonly) NSDictionary          *funcArgs;

/////////////
/**
    a pattern for clip value;*/
@property(readonly) NSString            *pattern;

//////////////////
/**
    exclusive with pattern;prefix of target value;not included;*/
@property(readonly) NSString            *prefixToClip;
/**
    exclusive with pattern;suffix of target value;not included;*/
@property(readonly) NSString            *suffixToClip;

//////////////////////
/******   transform parameter(only for numerical data:Vt = Vs * factor + increment)   ******/
@property(readonly) double              factor;
@property(readonly) double              increment;
@property NSUInteger                    precision;  // the number of decimal digits, must no less than 0


- (instancetype)initWithParamDic:(NSDictionary *) paramDic;

- (NSString *)processValue:(NSString *) value withParamDic:(NSDictionary *)paramDic;

@end
