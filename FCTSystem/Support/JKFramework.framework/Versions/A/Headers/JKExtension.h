//
//  NSExtension.h
//  JKFramework
//
//  Created by Jack.MT on 16/6/27.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
/*------------NSDate-----------------*/
@interface NSDate(DateFormat)

/**
 日期的格式化字符串*/
-(NSString *)stringWithFormat:(NSString *) format;

@end


/*-----------NSString---------------*/
@interface NSString(JKExtension)

/**
 十六进制形式的字符串的数值*/
-(int)hexValue;
//-(NSString *) stringByDecreaseBackSlant;
/**
 return a string*/
+ (NSString *)hexStringWithUnsignedIntValue:(unsigned int)value;
+ (NSString *)hexStringWithUnsignedLongValue:(unsigned long) value;

+ (NSString *)dateStringWithFormat:(NSString *) format;

/**
 将字符串形式的控制字符还原成控制字符*/
- (NSString *)stringByRestoreInvisibleCharacter;
/**
 转换字符串，使控制字符格式化显示*/
- (NSString *)stringByDisplayInvisableCharacter;

@end

/*-----------NSData---------------*/
@interface NSData(JKExtension)

+ (instancetype)dataFromHexString:(NSString *) hexString;

@end


/*-------------JKAlert--------------*/
@interface JKAlert : NSAlert

@end


/*--------------JKDeepCoping------------*/
@protocol JKDeepCoping <NSObject>

/**
 深度Copy protocol
 **/
- (instancetype)deepCopy;
- (instancetype)mutableDeepCopy;

@end

/*-----------NSMutableDictionary------------*/
/// NSDictionary(JKVC)
@interface NSMutableDictionary(JKKVC)

- (void)addValue:(id)value forKeyPath:(NSString *)keyPath;

@end

/*------------NSDictionary--------------*/
/// NSDictionary(NSDictionaryCreationFromString)
@interface NSDictionary(JKDictionaryExtension)<JKDeepCoping>

/**
 Create a Dictionary From String.
 The fommat of the string must be "Key1":"Value1",( \r\n\t)+"Key2":"Value2"*/
+ (instancetype)dictionaryFromString:(NSString *)dictionaryString;

/**
 return an string that whick format is <Key1:Value1, Key2:Value2, ...>*/
- (NSString *)dictionaryString;

@end



/*----------------NSArray--------------*/
@interface NSArray(JKArrayExtension)<JKDeepCoping>

@end


/*--------------NSObject-------------*/
@interface NSObject(JKArrayKVC)

- (id)valueForKeyPath:(NSString *)keyPath;
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;

@end
