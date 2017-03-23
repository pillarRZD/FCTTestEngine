//
//  JKSFCClient.h
//  JKFramework
//
//  Created by Jack.MT on 16/7/5.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>


/** UUT State */
typedef NS_ENUM(Byte, UNIT_STATE)
{
    /**
     unit can be test     */
    UNIT_OK,
    /**
     some station before current station does not test it     */
    UNIT_NOT_CURRENT_STATION,
    /**
     the unit has passed current station     */
    UNIT_PASSED,
    /**
     the unit is bad     */
    UNIT_LIMIT
};

@interface JKSFCClient : NSObject

+ (instancetype)client;
/**
 query the value of special key relative to an unit with special serialnumber */
- (NSString *)queryValueForKey:(NSString *)key andSN:(NSString *) serialNumber;
/**
 query the values of special keys relative to an unit with special serialnumber */
- (NSArray *)queryValuesForKeys:(NSArray *) keys andSN:(NSString *) serialNumber;
/**
 check unit */
- (NSString *)checkUnitWithSerialNumber:(NSString *) serialnumber;

- (NSString *)getHistoryForSerialNumber:(NSString *)serialnumber;

@end
