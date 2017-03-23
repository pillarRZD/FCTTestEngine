//
//  DUTController.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "TestEngine.h"
#import "AppConfig.h"
//#import "CSVLogDevice.h"

#import "JKZMQObjC.h"
#import "ZMQPorts.h"

#import "Publisher.h"
#import "RPCRequester.h"
#import "RPCResponder.h"

#import "Sequence.h"
#import "SequencerProxy.h"

@interface TestEngine()<MessageHandlerProtocol>

@end

@implementation TestEngine
{
    NSInteger           _site;
    JKTimer             *_timer;
    
    Publisher           *_publisher;
    RPCRequester        *_requester;
    RPCResponder        *_responder;
    
    SequencerProxy      *_sequencerProxy;
    
    NSMutableDictionary *_valueBuffer;
}

- (instancetype)initForSite:(NSInteger)site
{
    self = [super init];
    
    if(self)
    {
        _site = site;
        
        NSString *identifier = [NSString stringWithFormat:@"TestEngine_%ld",site];
        //初始化Publisher
        _publisher = [[Publisher alloc] initWithIdentifier:identifier
                                                  endpoint:[NSString stringWithFormat:@"tcp://*:%ld", [ZMQPorts sharedZMQPorts].TEST_ENGINE_PUB+site]];
        
        //初始化 Requester ;
        _requester = [[RPCRequester alloc] initWithIdentifier:identifier
                                                     endpoint:[NSString stringWithFormat:@"tcp://localhost:%ld", [ZMQPorts sharedZMQPorts].TEST_ENGINE_PORT+site]];
        
        //初始化 Responder to Sequencer
        _responder = [[RPCResponder alloc] initWithIdentifier:identifier
                                                     endpoint:[NSString stringWithFormat:@"tcp://*:%ld", [ZMQPorts sharedZMQPorts].TEST_ENGINE_PORT+site]];
        [_responder startListen4Caller:self];   //启动监听
        
        _valueBuffer = [NSMutableDictionary dictionary];
        
        //初始化并启动 Sequencer
        _sequencerProxy = [[SequencerProxy alloc] initWithSite:site];
        [_sequencerProxy launchSequencerAtPath:[AppConfig config].sequencerPath continueOnFail:[AppConfig config].continueOnFail];
    }
    
    return self;
}


- (id)handleMessage:(NSDictionary *)dicMessage
{
    NSString *func              = [dicMessage objectForKey:kZMQ_Method];
    NSArray *args               = [dicMessage objectForKey:kZMQ_Args];
    NSDictionary *kwArgs        = [dicMessage objectForKey:kZMQ_KWArgs];
    
    return [self runFunc:func withArgs:args andKWArgs:kwArgs];
}

- (id)runFunc:(NSString *)func withArgs:(NSArray *)args andKWArgs:(NSDictionary *)kwArgs
{
    NSString *retValue;
    func = [func stringByAppendingString:@":"];
    NSMutableArray *newArgs = [NSMutableArray arrayWithArray:args];
    [newArgs addObject:kwArgs];
    
    id dev = [self device4Func:func];
    if(dev)
    {
        SuppressPerformSelectorLeakWarning(retValue, [dev performSelector:NSSelectorFromString(func) withObject:newArgs]);
    }
    else
    {
        if([self respondsToSelector:NSSelectorFromString(func)])
        {
            SuppressPerformSelectorLeakWarning(retValue, [self performSelector:NSSelectorFromString(func) withObject:newArgs]);
        }
        else
        {
            retValue = [NSString stringWithFormat:@"--FAIL--No function named %@", func];
        }
    }
    
    return retValue;
}

- (id)device4Func:(NSString *)func
{
    for(NSString *devName in [JKDeviceManager sharedManager].deviceDictionary.allKeys)
    {
        id dev = [[JKDeviceManager sharedManager] deviceWithName:devName];
        if([dev respondsToSelector:NSSelectorFromString(func)])
        {
            if([devName containsString:@"#"])
            {
                NSArray *nameComponents = [devName componentsSeparatedByString:@"#"];
                NSString *newDevName = [NSString stringWithFormat:@"%@#%ld", nameComponents[0], _site+1];
                dev = [[JKDeviceManager sharedManager] deviceWithName:newDevName];
            }
            return dev;
        }
    }
    
    return nil;
}

- (void)close
{
    [_responder close];
    [_requester close];
    [_publisher close];
    
    [_sequencerProxy exit];
}


- (NSString *)delay:(NSArray *)args
{
    double delayTime = [args[0] doubleValue]/1000 - 0.1;
    [NSThread sleepForTimeInterval:delayTime];
    return [NSString stringWithFormat:@"delay %@s", @([args[0] doubleValue]/1000)];
}

- (NSString *)parse:(NSArray *)args
{
    return [NSString stringWithFormat:@"%@.%s", self.className, __func__];
}

@end
