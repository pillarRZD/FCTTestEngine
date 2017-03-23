//
//  RPCResponder.m
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/18.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import "RPCResponder.h"
#import "AppConfig.h"
#import "JKZMQObjC.h"

@implementation RPCResponder
{
    JKZMQContext        *_zmqContext;
    JKZMQSocket         *_responseSkt;
}

- (instancetype)initWithIdentifier:(NSString *)identifier endpoint:(NSString *)endpoint
{
    self = [super init];
    if(self)
    {
        _zmqContext = [[JKZMQContext alloc] initWithIOThreads:1];
        _responseSkt    = [_zmqContext socketWithType:ZMQ_REP];
        if(![_responseSkt bindToEndpoint:endpoint])
        {
            @throw [NSException exceptionWithName:@"ZMQ Exception" reason:[NSString stringWithFormat:@"%@ bind to endpiont<%@> failed", self, endpoint] userInfo:nil];
        }
    }
    
    return self;
}

- (void)startListen4Caller:(id<MessageHandlerProtocol>)caller
{
    JKTimer *timer = [JKTimer timer];
    [NSThread detachNewThreadWithBlock:^(){
       NSError *err = nil;
        [timer start];
       while([NSThread mainThread].isExecuting && !_responseSkt.closed)
       {
           NSData *reqData = [_responseSkt receiveDataWithFlags:ZMQ_DONTWAIT];
           
           if(reqData.length > 0)
           {
               id msgObj = [NSJSONSerialization JSONObjectWithData:reqData options:0 error:&err];
               msgObj = msgObj?:[[NSString alloc] initWithData:reqData encoding:kZMQEncoding];
               
               NSString *topic = [[NSString alloc] initWithData:reqData encoding:kZMQEncoding];
               NSMutableArray *multiData = [@[topic] mutableCopy];
               
               NSData *recvMoreFlag = [_responseSkt dataForOption:ZMQ_RCVMORE];
               NSData *recvMoreRefFlag = [NSData dataFromHexString:@"01000000"];
               if([recvMoreFlag isEqualToData:recvMoreRefFlag])
               {
                   do
                   {
                       NSData *moreData = [_responseSkt receiveDataWithFlags:0];
                       id msgObj = [NSJSONSerialization JSONObjectWithData:moreData options:0 error:&err];
                       msgObj = msgObj?:[[NSString alloc] initWithData:moreData encoding:kZMQEncoding];
                       [multiData addObject:msgObj];
                       
                       recvMoreFlag = [_responseSkt dataForOption:ZMQ_RCVMORE];
                   }while ([recvMoreFlag isEqualToData:recvMoreRefFlag]);  //数据未读取完全
               }
           
               if(caller)
               {
                   NSDictionary *dicMessage = [NSJSONSerialization JSONObjectWithData:reqData options:0 error:&err];
                   
                   id response = [caller handleMessage:dicMessage];
                   
                   dicMessage = @{kZMQ_JSONRPC:[dicMessage objectForKey:kZMQ_JSONRPC],
                                  kZMQ_ID:[dicMessage objectForKey:kZMQ_ID],
                                  kZMQ_Result:response ?: @""};
                   [_responseSkt sendData:[NSJSONSerialization dataWithJSONObject:dicMessage options:0 error:&err] withFlags:0];
               }
           }
           
           [NSThread sleepForTimeInterval:0.005];
       }
    }];
}

- (void)close
{
    [_responseSkt close];
}

@end
