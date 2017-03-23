//
//  BaseMudole.h
//  Test
//
//  Created by Jack.MT on 16/7/6.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JKTestMacro.h"

@class JKLogMessage;


@interface JKBaseDevice : NSObject<NSCopying>
{
    BOOL            _exist;
    BOOL            _opened;
    NSDictionary    *_devConfig;
}

@property(nonatomic, readonly) NSString     *configName;

/**
 An flag Indicating whether the device is opened*/
@property(readonly) BOOL                        exist;
@property(readonly) BOOL                        opened;
@property JKLogMessage                          *logMessage;
@property( readonly) NSDictionary               *devConfig;

@property(nonatomic, readonly) double           readInterval;//the time interval between two read-operation, used in JKCommAction

@property(readonly) NSString                    *logFilePath;

@property(nonatomic) NSInteger                  refCount;


@property NSImageView       *indicatorLight;

/**
 process for test at begin.
 if override it in subclass,you must call [super testBeginWithParamDic:paramDic] at the begin of implement*/
- (void)testBeginWithParamDic:(NSDictionary *)paramDic;
/**
 process for test at end.
 if override it in subclass,you must call [super testBeginWithParamDic:paramDic] at the begin of implement*/
- (void)testEndWithParamDic:(NSDictionary *)paramDic;

/**
 Initialize an instance of JKBaseDevice with parameters contained in an NSDictionary*/
- (instancetype)initWithConfig:(NSDictionary *) config;

/**
 */
//-(void)runOperation:(JKOperation *)operation withParamDic:(NSDictionary *)paramDic;

/**
 send command.it can be overrided by subclass
 @param command an command for communication
 @return if excute successfully. return nil, otherwise return a string contains error message*/
- (NSString *)sendCommand:(NSString *) command withParamDic:(NSDictionary *)paramDic;
- (NSString *)sendByteCommand:(Byte *)bytesCmd withParamDic:(NSDictionary *)paramDic;

/**
 return feedback from device.it is usually called after method 'sendCommand' called.it can be overrided by subclass*/
- (NSString *)readFeedBackWithParamDic:(NSDictionary *)paramDic;

- (NSData *)readBytesWithParamDic:(NSDictionary *)paramDic;

#ifdef MT_TEST_PLATFORM
/**
 used to synchronize communication*/
- (NSString *)synch:(NSDictionary *)paramDic;
- (NSString *)synchEnd:(NSDictionary *)paramDic;

/**
 delay for some time*/
- (NSString *)delay:(NSDictionary *)paramDic;

/**
 add value to buffer*/
- (NSString *)addBuffer:(NSDictionary *)paramDic;

/**
 check the connection between device and PC*/
- (NSString *)checkConnection:(NSDictionary *)paramDic;

/**
 open device(communication function)*/
- (NSString *)open:(NSDictionary *)paramDic;

/**
 close device(communication function)*/
- (NSString *)close:(NSDictionary *)paramDic;

/**
 弹出提示对话框*/
- (NSString *)alert:(NSDictionary *)paramDic;
#endif

/**
 open the device. it can be overrided by subclass*/
- (BOOL)open;
/**
 close the device.it can be overrided by subclass*/
- (void)close;

/**
 methods for Log
 */
- (void)createLogFileWithParamDic:(NSDictionary *) paramDic;
- (void)writeLog:(NSString *)log withParamDic:(NSDictionary *) paramDic;


+ (NSDictionary *)requiredConfigList;
+ (NSDictionary *)fullConfigList;


- (NSString *)argForKey:(NSString *)argKey inParamDic:(NSDictionary *)paramDic;

@end



@interface NSDictionary(JKExtensionForTest)

- (id)argForKey:(NSString *)key;
- (void)setArg:(id)arg forKey:(NSString *)key;

@end
