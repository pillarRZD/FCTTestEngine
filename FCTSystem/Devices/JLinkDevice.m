//
//  JLinkDevice.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/15.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "JLinkDevice.h"
#import "AppConfig.h"

#define SSHHEADER @"==Begin=="
#define SSHENDLINE @"==End=="
#define SSHTIMEOUT @"==Timeout=="

@implementation JLinkDevice
{
    NSString    *_scriptPath;
    NSTask      *_commTask;
    NSPipe      *_iPipe;
    NSPipe      *_oPipe;
    
    NSString    *_portPath;
    
    NSString            *_currentCmd;
    NSMutableString     *_commData;
    NSMutableString     *_currentData;
    BOOL _canRead;
}

static dispatch_once_t  jlinkDeviceOnceToken;
static NSLock *syncJLinkLock;
-(instancetype)initWithConfig:(NSDictionary *)paramDic
{
    self = [super initWithConfig:paramDic];
    
    if(self)
    {
        dispatch_once(&jlinkDeviceOnceToken, ^(){
            syncJLinkLock = [[NSLock alloc] init];
        });
        int count = 0;
        do{
            _scriptPath = [[NSBundle mainBundle] pathForResource:[[AppConfig config] valueForKeyPath:@"General.JLinkScriptName"] ofType:@"sh"];
        }while(_scriptPath == nil && count++<5);
        _portPath = [paramDic objectForKey:@""];
        
        NSError *err = nil;
        NSString *cmdFilePath = [paramDic valueForKeyPath:@"Buffer.CommandFile"];
        NSString *cmdFileDir = [cmdFilePath stringByDeletingLastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:cmdFileDir] == NO)
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:cmdFileDir withIntermediateDirectories:YES attributes:nil error:&err];
        }
        
        if([[NSFileManager defaultManager] fileExistsAtPath:cmdFilePath] == NO)
        {
            NSString *backUpFilePath = [[NSBundle mainBundle] pathForResource:@"STM32CmdFile" ofType:@"txt"];
            [[NSFileManager defaultManager] copyItemAtPath:backUpFilePath toPath:cmdFilePath error:&err];
        }
//        [self openSSH];
    }
    
    return self;
}

-(BOOL)opened
{
    return YES;
}

- (NSString *)sendCommand:(NSString *)command withParamDic:(NSDictionary *)paramDic
{
    NSString *retValue = nil;
    
    if(_scriptPath)
    {
        if(_commTask && _commTask.isRunning)
        {
            NSString *cmd = [NSString stringWithFormat:@"kill %d", _commTask.processIdentifier];
            system([cmd UTF8String]);
        }
        
        _commTask = [[NSTask alloc] init];
        _commTask.launchPath = @"/bin/sh";
        _commTask.arguments = [NSArray arrayWithObjects:_scriptPath, command ? command : @"echo 'nil command'", nil];
        _oPipe = [NSPipe pipe];
        for(int i=0; _oPipe == nil && i<5; i++)
        {
            _oPipe = [NSPipe pipe];
        }
        _commTask.standardOutput = _oPipe;
        
        _canRead = YES;
        [_commTask launch];
    }
    else
    {
        retValue = [NSString stringWithFormat:@"Communication Error<JLink Script Path is nil>"];
    }
    return retValue;
}

-(void)sendCommand:(NSString *)command
{
    _canRead = YES;
    [_iPipe.fileHandleForWriting writeData:[command dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)readFeedBackWithParamDic:(NSDictionary *)paramDic
{
    NSString *retValue = nil;
    
//    if(_commTask.isRunning == NO)
//    {
        NSData *data = _oPipe.fileHandleForReading.availableData;           //availableData会阻塞线程
        retValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
    
    return retValue;
}

-(void)readData
{
    NSData *data;
    NSString *tmp = nil;
    NSError *err = nil;
    NSString *patternHeader = @"\n==Begin==";
    //    NSString *patternTail = @"echo ==End==";
    NSRegularExpression *regexHeader = [[NSRegularExpression alloc] initWithPattern:patternHeader options:0 error:&err];
    //    NSRegularExpression *regexTail = [[NSRegularExpression alloc] initWithPattern:patternTail options:0 error:&err];
    @try {
        while(_commTask && _commTask.isRunning && _oPipe)
        {
            if([data = _oPipe.fileHandleForReading.availableData length])
            {
                tmp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //            @synchronized(sycObj) {
                [_commData appendFormat:@"%@", tmp];
                if(_canRead)
                {
                    [_currentData appendString:tmp];
                    NSString *pattern = [NSString stringWithFormat:@"%@([\x00-\x7F]+)(==End==)|(==Timeout==)", _currentCmd];
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&err];
                    if([regex matchesInString:_currentData options:0 range:NSMakeRange(0, _currentData.length)].count > 0)
                    {
                        if(![_currentData containsString:SSHHEADER])
                        {
                            NSArray *results = [regexHeader matchesInString:_commData options:0 range:NSMakeRange(0, _commData.length)];
                            NSTextCheckingResult *result = [results lastObject];
                            _currentData = [[_commData substringFromIndex:result.range.location] mutableCopy];
                        }
                        _canRead = NO;
                    }
                }
            }
            [NSThread sleepForTimeInterval:0.01];
        }
    }
    @catch (NSException *exception) {
        self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"(%@)An exception occured while readData:\n%@", self.class, exception] withLevel:MSG_WARNING];
//        [self closeSSH];
    }
    @finally {
        
    }
}


@end
