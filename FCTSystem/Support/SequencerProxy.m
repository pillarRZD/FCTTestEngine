//
//  SequencerProxy.m
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/21.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import "SequencerProxy.h"
#import <JKFramework/JKFramework.h>
#import "AppConfig.h"

@implementation SequencerProxy
{
    NSInteger   _site;
    
    NSTask      *_task;
    NSPipe      *_iPipe;
    NSPipe      *_oPipe;
}

- (instancetype)initWithSite:(NSInteger)site
{
    self = [super init];
    
    if(self)
    {
        _site = site;
        
        _task = [[NSTask alloc] init];
        _task.launchPath = @"/usr/bin/expect";
        
        _iPipe = [NSPipe pipe];
        _oPipe = [NSPipe pipe];
        _task.standardInput  = _iPipe;
        _task.standardOutput = _oPipe;
        _task.standardError  = _oPipe;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReady:) name:NSFileHandleDataAvailableNotification object:_oPipe.fileHandleForReading];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proxyTerminated:) name:NSTaskDidTerminateNotification object:_task];
        [_oPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    }
    
    return self;
}

- (void)launchSequencerAtPath:(NSString *)sequencerPath continueOnFail:(BOOL)continueOnFail
{
    NSString *pyCmd = [NSString stringWithFormat:@"python %@ %@ -s %ld", sequencerPath, continueOnFail?@"-c":@"", _site];
    _task.arguments = @[@"-c", pyCmd];
    
    NSString *expPath   = [[NSBundle mainBundle] pathForResource:@"runSequencer" ofType:@"exp"];
    NSString *userName  = [JKUtility currentUserName];
    NSString *pwd       = [userName hasPrefix:@"gd"] ? userName : [AppConfig config].userPWD;
    NSString *continueOnFailFlag = continueOnFail ? @"1" : @"0";
    NSString *site  = [NSString stringWithFormat:@"%ld", _site];
    _task.arguments = @[expPath, userName, pwd, sequencerPath, continueOnFailFlag, site];

    @try {
            [_task launch];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception.reason);
    }
    @finally {
    }
}

- (void)dataReady:(NSNotification *)notification
{
}

- (void)proxyTerminated:(NSNotification *)notification
{
    NSLog(@"Site %ld: sequecencer proxy terminated!", _site);
}

- (void)exit
{
    if(_task.isRunning)
    {
        NSString *quitCmd = [NSString stringWithFormat:@"%c", 0x3];
        [_iPipe.fileHandleForWriting writeData:[quitCmd dataUsingEncoding:NSUTF8StringEncoding]];
        [_task terminate];
    }
}

@end
