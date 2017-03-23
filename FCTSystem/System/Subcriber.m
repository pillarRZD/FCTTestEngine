//
//  Subscriber.m
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/18.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import "Subcriber.h"
#import "JKZMQObjC.h"
#import "ZMQPorts.h"
#import "AppConfig.h"

@implementation Subcriber
{
    JKTimer         *_heartBeatCheckTimer;
    JKZMQContext    *_zmqContext;
    JKZMQSocket     *_subcribeSkt;
    
    NSString        *_endpoint;
}

- (instancetype)initWithIdentifier:(NSString *)identifier endpoint:(NSString *)endpoint
{
    self = [super init];
    if(self)
    {
        _identifier = identifier;
        
        _heartBeatCheckTimer = [JKTimer timer];
        
        _zmqContext = [[JKZMQContext alloc] initWithIOThreads:1];
        _subcribeSkt = [_zmqContext socketWithType:ZMQ_SUB];
        [_subcribeSkt setData:[[ZMQPorts sharedZMQPorts].PUB_CHANNEL  dataUsingEncoding:NSUTF8StringEncoding] forOption:ZMQ_SUBSCRIBE];
        [_subcribeSkt connectToEndpoint:endpoint];
        
        _endpoint = endpoint;
    }
    return self;
}

- (void)close
{
    [_subcribeSkt close];
}

static double kHeartBeatTimeout = 10;
- (void)subcribe4Caller:(id<MessageHandlerProtocol>)caller
{
    [_heartBeatCheckTimer start];
    [NSThread detachNewThreadWithBlock:^(){
        NSError *err = nil;
        while([NSThread mainThread].isExecuting && !(_subcribeSkt.closed))
        {
            NSData *pubData = [_subcribeSkt receiveDataWithFlags:ZMQ_DONTWAIT];
            if(pubData.length > 0)
            {
                id msgObj = [NSJSONSerialization JSONObjectWithData:pubData options:0 error:&err];
                msgObj = msgObj?:[[NSString alloc] initWithData:pubData encoding:kZMQEncoding];

                NSString *topic = [[NSString alloc] initWithData:pubData encoding:kZMQEncoding];
                NSMutableArray *multiData = [@[topic] mutableCopy];
                
                NSData *recvMoreFlag = [_subcribeSkt dataForOption:ZMQ_RCVMORE];
                NSData *recvMoreRefFlag = [NSData dataFromHexString:@"01000000"];
                if([recvMoreFlag isEqualToData:recvMoreRefFlag])
                {
                    do
                    {
                        NSData *moreData = [_subcribeSkt receiveDataWithFlags:0];
                        id msgObj = [NSJSONSerialization JSONObjectWithData:moreData options:0 error:&err];
                        msgObj = msgObj?:[[NSString alloc] initWithData:moreData encoding:kZMQEncoding];
                        [multiData addObject:msgObj];
                        
                        recvMoreFlag = [_subcribeSkt dataForOption:ZMQ_RCVMORE];
                    }while ([recvMoreFlag isEqualToData:recvMoreRefFlag]);  //数据未读取完全
                }
                if(caller)
                {
                    [caller handleMessage:multiData];
                }

                [_heartBeatCheckTimer start];
            }
            
            [NSThread sleepForTimeInterval:0.005];
        }
    }];
}

@end
