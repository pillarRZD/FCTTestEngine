//
//  JKAppConfig.h
//  JKFramework
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKMessageViewController.h"

#define EXCEPTION_ALL_MASK    (1<<10)-1
#define EXCEPTION_HANDLE_MASK   (1<<1|1<<3|1<<5|1<<7|1<<9)
#define EXCEPTION_LOG_MASK      (1<<0|1<<2|1<<4|1<<6|1<<8)

typedef NS_ENUM(NSUInteger, STEPRUN_LEVEL){
    STEPRUN_DISABLE,
    STEPRUN_ITEM,
    STEPRUN_OPERATION,
    STEPRUN_LEVEL_COUNT
};

typedef NS_ENUM(NSUInteger, LOG_MODEL){
    LM_DUT,
    LM_DEVICE,
    LOG_MODEL_COUNT
};

/**
 An class for read and write application config; it will read-write the config file named "AppConfig" in resource directory of current application; */
@interface JKAppConfig : NSObject
{
@protected
    NSDictionary    *_infoDictionary;
}

/**
 Shared instance of JKAppconfig */
+ (instancetype)config;

/**
 synchronize the config of config-file with the buffer(Store config in buffer to file) */
- (void)synchronize;

/**
 get application name*/
- (NSString *)appName;
/**
 get application version*/
- (NSString *)appVersion;
/**
 get the executable path of application*/
- (NSString *)executablePath;
/**
 get the resource path in the bundle of application*/
- (NSString *)resourcePath;
/**
 get the root directory for data-collection of app*/
- (NSString *)rootDataDirectory;

/**
 the model to write log(DUT-base or Device-base) */
@property(nonatomic) LOG_MODEL  logModel;

/**
 the level of step-run mode of application*/
@property(nonatomic) STEPRUN_LEVEL appStepRunLevel;

/**
 a shower using to show system message*/
@property JKMessageViewController   *sysMessageShower;

#define kNormalRunMode             @"Normal"
/**
 系统支持的所有运行模式*/
@property(nonatomic) NSArray<NSString *>            *supportedRunModes;
/**
 当前系统的运行模式*/
@property(nonatomic) NSString                       *currentRunMode;
/**
 系统的初始运行模式*/
@property(nonatomic) NSString                       *initialRunMode;


/**
 get the map-value for the map-key.the map-type is indicated by mapType(eg:ProductType)*/
- (id)mapValueForKey:(NSString *) mapKey ofType:(NSString *)mapType;
/**
 set the map-value for the map-key.the map-type is indicated by mapType(eg:ProductType)*/
- (void)setMapValue:(id)mapValue forMapKey:(NSString *)mapKey ofType:(NSString *)mapType;

/**
 get the value at the keyPatn in config; */
- (id)valueForKeyPath:(NSString *)keyPath;
/**
 set the value at the keyPatn in config; */
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;

/**
 get the value at the keyPatn in config; */
+ (id)valueForKeyPath:(NSString *)keyPath;
/**
 set the value at the keyPatn in config; */
+ (void)setValue:(id)value ForKeyPath:(NSString *)keyPath;

/**
 get the value in global buffer with key-path */
+ (id)bufferValueForKeyPath:(NSString *)keyPath;
/**
 add the value in global buffer with key-path */
+ (void)addBufferValue:(id)value forKeyPath:(NSString *)keyPath;
///**
// remove the value with key-path from global buffer */
//+ (void)removeBufferForKeyPath:(NSString *)keyPath;
/**
 get the value in global buffer with keyPath for special dut(the index is 1-base) */
+ (id)bufferValueForKeyPath:(NSString *)keyPath andDUTIndex:(NSInteger)dutIndex;

- (void)addProcessIDInBackgourd:(int)pid;
- (void)killAllProcessInBackgourd;

- (void)logAppExceptionWithMask:(NSUInteger)exMask;

@end
