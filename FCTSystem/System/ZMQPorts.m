//
//  ZMQPorts.m
//  FCT(N121)
//
//  Created by Jack.MT on 2017/3/16.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import "ZMQPorts.h"

static ZMQPorts *instance;
@implementation ZMQPorts
{
    NSDictionary *portSet;
}

static dispatch_once_t initToken;
- (instancetype)init
{
    dispatch_once(&initToken, ^(){
        NSString *jsonPath = [NSHomeDirectory() stringByAppendingPathComponent:@"desktop/zmqports.json"];
        NSData *portData = [NSData dataWithContentsOfFile:jsonPath];
        NSError *err = nil;
        portSet = [NSJSONSerialization JSONObjectWithData:portData options:0 error:&err];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if(!instance)
        {
            instance = [super allocWithZone:zone];
        }
    }
    
    return instance;
}

- (instancetype)copy
{
    return self;
}

+ (instancetype)sharedZMQPorts
{
    @synchronized (self) {
        if(!instance)
        {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}


- (NSInteger)STATEMACHINE_PORT
{
    return [[portSet objectForKey:kSTATEMACHINE_PORT] integerValue];
}

- (NSInteger)STATEMACHINE_PUB
{
    return [[portSet objectForKey:kSTATEMACHINE_PUB] integerValue];
}

- (NSInteger)SEQUENCER_PORT
{
    return [[portSet objectForKey:kSEQUENCER_PORT] integerValue];
}


- (NSInteger)SEQUENCER_PUB
{
    return [[portSet objectForKey:kSEQUENCER_PUB] integerValue];
}


- (NSInteger)TEST_ENGINE_PORT
{
    return [[portSet objectForKey:kTEST_ENGINE_PORT] integerValue];
}


- (NSInteger)TEST_ENGINE_PUB
{
    return [[portSet objectForKey:kTEST_ENGINE_PUB] integerValue];
}


- (NSInteger)UART_PUB
{
    return [[portSet objectForKey:kUART_PUB] integerValue];
}


- (NSInteger)UART2_PUB
{
    return [[portSet objectForKey:kUART2_PUB] integerValue];
}


- (NSInteger)FIXTURE_CTRL_PORT
{
    return [[portSet objectForKey:kFIXTURE_CTRL_PORT] integerValue];
}


- (NSInteger)FIXTURE_CTRL_PUB
{
    return [[portSet objectForKey:kFIXTURE_CTRL_PUB] integerValue];
}

- (NSInteger)GUI_PORT
{
    return [[portSet objectForKey:kGUI_PORT] integerValue];
}

- (NSInteger)ARM_PUB
{
    return [[portSet objectForKey:kARM_PUB] integerValue];
}

- (NSInteger)LOGGER_PUB
{
    return [[portSet objectForKey:kLOGGER_PUB] integerValue];
}


- (NSString *)PUB_CHANNEL
{
    return [portSet objectForKey:kPUB_CHANNEL];
}

- (NSInteger)portForKey:(NSString *)portKey
{
    return [[portSet objectForKey:portKey] integerValue];
}

@end
