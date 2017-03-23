//
//  TcpDevice.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/10.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "WinPCDevice.h"
@import JKFramework;
#import "AppConfig.h"

#import <math.h>
#import <Accelerate/Accelerate.h>


@implementation WinPCDevice
{
    double          _checkInterval;
    
//    BOOL _exist;
}

static NSThread             *chkServThread;
static BOOL                 exist = NO;
static NSLock               *syncLock;
- (instancetype)initWithConfig:(NSDictionary *)paramDic
{
    if(syncLock == nil)
    {
        syncLock = [[NSLock alloc] init];
    }
    
    [syncLock lock];
    self = [super initWithConfig:paramDic];
    
    if(self)
    {
        _checkInterval  = [[paramDic valueForKeyPath:@"CheckInterval"] doubleValue];
        
        if(chkServThread == nil || chkServThread.isExecuting == NO)
        {
            chkServThread = [[NSThread alloc] initWithTarget:self selector:@selector(checkServer) object:nil];
            [chkServThread start];
            [self startCheckServer];
        }

        
//        if([checkThreadDictionary.allKeys containsObject:self.configName] == YES)
//        {
//            NSThread *thread = (NSThread *)[checkThreadDictionary objectForKey:self.configName];
//            [thread cancel];
//            while(thread.isExecuting)
//            {
//                [NSThread sleepForTimeInterval:0.05];
//            }
//        }
//        
//        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(checkServer) object:nil];
//        [checkThreadDictionary setObject:thread forKey:self.configName];
//        [thread start];
    }
    [syncLock unlock];
    
    return self;
}


- (void)checkServer
{
//    NSString *pPath = _serverIP;
    NSLog(@"[%@]<< Check-Server_Thread(%@) Begin", self.configName, [NSThread currentThread]);
    int retValue;
    while(self)
    {
        [syncLock lock];
        @autoreleasepool {
            NSString *cmd = [NSString stringWithFormat:@"ping -c1 -t1 %@ | grep '1 packets received' > /dev/null", self.serverIP];
            retValue = system([cmd UTF8String]);
        }
        
        BOOL ok = (retValue == 0);
        if(ok)
        {
            if(exist == NO)
            {
                self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Server{%@:%ld} present", self.configName, self.serverIP, self.serverPort]];
            }
        }
        else
        {
            if(exist)
            {
                self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] No Route to Server{%@:%ld}", self.configName, self.serverIP, self.serverPort] withLevel:MSG_WARNING];
                [self close];
            }
        }
        [syncLock unlock];
        exist = ok;
        
        if([NSThread currentThread].cancelled == NO
           && [NSThread mainThread].isExecuting)
        {
//            if(_exist && _opened == NO)
//            {
//                [self open];
//            }
            [NSThread sleepForTimeInterval:_checkInterval];
        }
        else
        {
            break;
        }

    }
    NSLog(@"[%@] Check-Server_Thread(%@) exit", self.configName, [NSThread currentThread]);
}

- (void)startCheckServer
{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/bash";
    task.standardInput = [NSPipe pipe];
    NSPipe *oPipe = [NSPipe pipe];
    task.standardOutput = task.standardError = oPipe.fileHandleForReading;
    
    task.arguments = @[@"-c", @"ping -c1 -t1 %@ | grep '1 packets received'"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReady:) name:NSFileHandleDataAvailableNotification object:oPipe.fileHandleForReading];
    [oPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTaskTerminated:) name:NSTaskDidTerminateNotification object:task];
    
    [task launch];
}

- (void)dataReady:(NSNotification *)notification
{
    NSPipe *oPipe = notification.object;
    NSFileHandle *fHandle = oPipe.fileHandleForReading;
    NSLog(@"%@", [[NSString alloc] initWithData:fHandle.availableData encoding:NSUTF8StringEncoding]);
}

- (void)checkTaskTerminated:(NSNotification *)notification
{
    NSLog(@"%@ checkTaskTeminated", self);
}

-(BOOL)exist
{
    return exist;
}

- (BOOL)opened
{
    return _connected;
}

@end
