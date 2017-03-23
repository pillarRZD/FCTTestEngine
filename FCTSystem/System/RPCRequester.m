//
//  RPCServer.m
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/18.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import "RPCRequester.h"
#import "JKZMQObjC.h"
#import "AppConfig.h"
#import "Protocol.h"

@implementation RPCRequester
{
    JKZMQContext        *_zmqContext;
    JKZMQSocket         *_requestSkt;
}

- (instancetype)initWithIdentifier:(NSString *)identifier endpoint:(NSString *)endpoint
{
    self = [super init];
    if(self)
    {
        _zmqContext = [[JKZMQContext alloc] initWithIOThreads:1];
        _requestSkt = [_zmqContext socketWithType:ZMQ_REQ];
        if(![_requestSkt connectToEndpoint:endpoint])
        {
            @throw [NSException exceptionWithName:@"ZMQ Exception" reason:[NSString stringWithFormat:@"%@ connect to endpiont<%@> failed", self, endpoint] userInfo:nil];
        }
    }
    
    return self;
}

#define kJSON_VER       @"2.0"
- (void)send:(NSString *)method
{
    NSDictionary *reqDic = @{kZMQ_JSONRPC:kJSON_VER, kZMQ_ID:[self getUniqueIdentifier], kZMQ_Method:method};
    [self sendRequest:reqDic];
}

- (void)send:(NSString *)method args:(NSArray *)args
{
    NSDictionary *reqDic = @{kZMQ_JSONRPC:kJSON_VER, kZMQ_ID:[self getUniqueIdentifier], kZMQ_Method:method, kZMQ_Args:args};
    [self sendRequest:reqDic];
}

- (void)send:(NSString *)method args:(NSArray *)args kwArgs:(NSArray *)kwArgs
{
    NSDictionary *reqDic = @{kZMQ_JSONRPC:kJSON_VER, kZMQ_ID:[self getUniqueIdentifier], kZMQ_Method:method, kZMQ_Args:args, };
    [self sendRequest:reqDic];
}


- (void)sendRequest:(NSDictionary *)request
{
    NSError *err = nil;
    NSData *reqData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&err];
    if(![_requestSkt sendData:reqData withFlags:0])
    {
        NSLog(@"fail to send data:<%@>", [[NSString alloc] initWithData:reqData encoding:kZMQEncoding]);
    }
}

- (NSString *)receive
{
    return [self receiveWithFlags:0];
}

- (NSString *)receiveWithFlags:(int)flags
{
    NSData *repData = [_requestSkt receiveDataWithFlags:flags];
    
    NSError *err = nil;
    NSDictionary *reply = [NSJSONSerialization JSONObjectWithData:repData options:0 error:&err];
    NSString *repStr = [[reply objectForKey:kZMQ_Result] description];
    if([reply.allKeys containsObject:kZMQ_Error])
    {
        repStr = [reply objectForKey:kZMQ_Error];
    }
    
    return repStr;
}

- (void)close
{
    [_requestSkt close];
}

- (NSString *)state
{
    return _requestSkt.error;
}

- (NSString *)getUniqueIdentifier
{
    NSArray *charSet = @[@"0", @"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f"];
    NSMutableString *uid = [NSMutableString string];
    for(int i=0; i<32; i++)
    {
        NSString *ch = charSet[arc4random() % charSet.count];
        [uid appendFormat:@"%@", ch];
    }
    
    return uid;
}

@end
