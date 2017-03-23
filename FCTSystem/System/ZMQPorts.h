//
//  ZMQPorts.h
//  FCT(N121)
//
//  Created by Jack.MT on 2017/3/16.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMQPorts : NSObject

+ (instancetype)sharedZMQPorts;

#define kSTATEMACHINE_PORT          @"SM_PORT"
- (NSInteger)STATEMACHINE_PORT;
#define kSTATEMACHINE_PUB           @"SM_PUB"
- (NSInteger)STATEMACHINE_PUB;

#define kSEQUENCER_PORT             @"SEQUENCER_PORT"
- (NSInteger)SEQUENCER_PORT;
#define kSEQUENCER_PUB              @"SEQUENCER_PUB"
- (NSInteger)SEQUENCER_PUB;

#define kTEST_ENGINE_PORT           @"TEST_ENGINE_PORT"
- (NSInteger)TEST_ENGINE_PORT;
#define kTEST_ENGINE_PUB            @"TEST_ENGINE_PUB"
- (NSInteger)TEST_ENGINE_PUB;

#define kUART_PUB                   @"UART_PUB"
- (NSInteger)UART_PUB;
#define kUART2_PUB                  @"UART2_PUB"
- (NSInteger)UART2_PUB;

#define kFIXTURE_CTRL_PORT          @"FIXTURE_CTRL_PORT"
- (NSInteger)FIXTURE_CTRL_PORT;
#define kFIXTURE_CTRL_PUB           @"FIXTURE_CTRL_PUB"
- (NSInteger)FIXTURE_CTRL_PUB;

#define kGUI_PORT                   @"GUI_PORT"
- (NSInteger)GUI_PORT;

#define kARM_PUB                    @"ARM_PUB"
- (NSInteger)ARM_PUB;

#define kLOGGER_PUB                 @"LOGGER_PUB"
- (NSInteger)LOGGER_PUB;

#define kPUB_CHANNEL                @"PUB_CHANNEL"
- (NSString *)PUB_CHANNEL;

- (NSInteger)portForKey:(NSString *)portKey;

@end
