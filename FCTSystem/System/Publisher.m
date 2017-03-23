//
//  Publisher.m
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/18.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import "Publisher.h"
#import "JKZMQObjC.h"
#import "ZMQPorts.h"
#import "AppConfig.h"

@implementation Publisher
{
    JKZMQContext    *_zmqContext;
    JKZMQSocket     *_publishSkt;
    
    NSDateFormatter     *_dateFormatter;
}

- (instancetype)initWithIdentifier:(NSString *)identifier endpoint:(NSString *)endpoint
{
    self = [super init];
    if(self)
    {
        _identifier     = identifier;
        
        _zmqContext = [[JKZMQContext alloc] initWithIOThreads:1];
        _publishSkt   = [_zmqContext socketWithType:ZMQ_PUB];
        [_publishSkt bindToEndpoint:endpoint];
        
        _dateFormatter  = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"hh:mm:ss.SSS";
    }
    
    return self;
}

- (void)publish:(NSString *)info
{
    [self publish:info idPostfix:nil level:DEBUG_LEVEL];
}

- (void)publish:(NSString *)info level:(PublisherLevel)level
{
    [self publish:info idPostfix:nil level:level];
}

- (void)publish:(NSString *)info idPostfix:(NSString *)id_postfix level:(PublisherLevel)level
{
    // 构建消息
    NSString *ts = [_dateFormatter stringFromDate:[NSDate date]];
    NSString *idStr = id_postfix ? [NSString stringWithFormat:@"%@--%@", self.identifier, id_postfix] : self.identifier;
    NSString *pubData = [NSString stringWithFormat:@"%@,%@,%ld,%@,%@"
                                                , [ZMQPorts sharedZMQPorts].PUB_CHANNEL
                                                , ts, level, idStr, info];
    
    // 广播
    [_publishSkt sendData:[pubData dataUsingEncoding:kZMQEncoding] withFlags:0];
}

- (void)close
{
    [_zmqContext closeSockets];
    [_zmqContext terminate];
}

@end
