//
//  DeviceManager.h
//  SA-Button_Test
//
//  Created by Jack.MT on 16/1/19.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKBaseDevice.h"

#define kCONFIG_OF_CHANNELS       @"ConfigOfChannels"

@interface JKDeviceManager : NSObject

@property JKLogMessage *logMessage;

@property(nonatomic, readonly) NSDictionary *deviceDictionary;
@property(nonatomic, readonly) NSDictionary *configDictionary;

- (BOOL) initAllDevices;
- (BOOL) resetAllDevices;
- (void) close;

/**
 return the shared device manager*/
+ (instancetype)sharedManager;
/**
 return a manager relative to a config*/
+ (instancetype)managerWithConfigFile:(NSString *)configPath;

/**
 device named devName in manager*/
- (JKBaseDevice *)deviceWithName:(NSString *)devName;
/**
 devices contains device whice name has prefix 'namePrefix'(Array of JKBaseDevice)*/
- (NSArray *)devicesWithNamePrefix:(NSString *)namePrefix;
/**
 name set that contains all name which contains prefix 'namePrefix'*/
- (NSArray *)deviceNamesWithPrefix:(NSString *)namePrefix;

- (void)testBeginWithParamDic:(NSDictionary *)paramDic;
- (void)testEndWithParamDic:(NSDictionary *)paramDic;

/**
 observe the keyPath of objObserved. */
- (void) observeObject:(id) objObserved forKeyPath:(NSString *) keyPath;
- (void) ignoreObject:(id) objObserved forKeyPath:(NSString *) keyPath;

@end
