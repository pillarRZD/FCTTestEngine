//
//  SelfController.m
//  SA-Button_Test
//
//  Created by Jack.MT on 16/1/20.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "SelfMudole.h"
#import "AppConfig.h"

#define DATAREADYFILE @"/volumes/Share/DataReady.txt"

#define ORIGINDATADIR @"Origin"
#define SMOOTHDATADIR @"Smooth"
#define FINALDATADIR @"Final"


@implementation NSArray(ArrayToCSV)

-(NSData *) dataFromArray
{
    NSMutableString *dataString = [[NSMutableString alloc] init];
    
    long _daqFreq = [[[AppConfig config] valueForKeyPath:@"ForceCurve.DAQ.Freq"] longValue];
    double timeStamp = 1.0 / _daqFreq;
    int idx = 0;
    for(NSString *data in self)
    {
        [dataString appendFormat:@"%.5lf,%@\n", timeStamp * idx++, data];
    }
    
    return [dataString dataUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation SelfMudole
{
    BOOL _initialized;
    long _daqFreq;
    
    //meanfilter parameters
    
    NSString *username;
    NSString *password;
    
    BOOL _shareFolderMounted;
    BOOL _winPCReady;
    NSThread *_checkWinPCThread;
    BOOL _checkInterval;
    BOOL _isDisposed;
    
    JKTimer *_timerForPointTest;
    double _testTimeOfPointTest;
}


-(BOOL)isWinPCReady
{
    return _winPCReady;
}

-(void) checkWinPCContinuous
{
    while(!_isDisposed)
    {
        _winPCReady = [self checkWinPCOnce];
        
        [NSThread sleepForTimeInterval:_checkInterval];
    }
}


-(instancetype)initWithParams:(NSDictionary *)paramDic
{
    _initialized = NO;
    self = [super initWithParamDic:paramDic];
    if (self) {

        username = [[AppConfig config] valueForKeyPath:@"WinPC.Username"];
        password = [[AppConfig config] valueForKeyPath:@"WinPC.Password"];
        _winPCReady = [self checkWinPCOnce];
        
        _timerForPointTest = [[JKTimer alloc] init];
        
        _initialized = YES;
        
        _checkInterval = [[paramDic valueForKeyPath:@"CheckInterval"] doubleValue];
        _checkWinPCThread = [[NSThread alloc] initWithTarget:self selector:@selector(checkWinPCContinuous) object:nil];
        [_checkWinPCThread start];
    }
    
    return self;
}

-(BOOL)checkWinPCOnce
{
    @synchronized(self) {
        if(!_initialized) self.logMessage = [JKLogMessage msgWithInfo:@"Checking WinPC..."];
        
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"checkWinPC" ofType:@"sh"];
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/bin/sh";
        task.arguments = [NSArray arrayWithObjects:scriptPath, nil];
        
        int count = 0;      //recreate times;
        NSPipe *outPipe = [NSPipe pipe];
        while(!outPipe && count++ < 5)
        {
            [NSThread sleepForTimeInterval:0.1];
            outPipe = [NSPipe pipe];
        }
        
        if(outPipe)
        {
            @try {
                task.standardOutput = outPipe;
                [task launch];
                
                while(task.isRunning)
                {
                    [NSThread sleepForTimeInterval:0.1];
                }
                //        [task waitUntilExit];
                
                NSString *data = [[NSString alloc] initWithData:[outPipe.fileHandleForReading availableData] encoding:NSUTF8StringEncoding];
                
                [outPipe.fileHandleForReading closeFile];
                [outPipe.fileHandleForWriting closeFile];
                NSString *dirShare = @"/volumes/Share";
                if([data containsString:@"WinPC Ready"])
                {
                    NSError *err = nil;
                    if(!_initialized || !_winPCReady) self.logMessage = [JKLogMessage msgWithInfo:@"Connected to WinPC"];
                    _winPCReady = YES;
                    
                    //            NSError *err = nil;
                    if(![[NSFileManager defaultManager] fileExistsAtPath:dirShare])
                    {
                        _shareFolderMounted = NO;
                        username = [[AppConfig config] valueForKeyPath:@"WinPC.Username"];
                        password = [[AppConfig config] valueForKeyPath:@"WinPC.Password"];
                        NSString *cmd = [NSString stringWithFormat:@"mkdir %@&&mount -t smbfs //%@:%@@169.254.88.80/Share %@", dirShare, username, password, dirShare];
                        if(!_initialized || !_shareFolderMounted) self.logMessage = [JKLogMessage msgWithInfo:@"Mounting share folder..."];
                        if(system([cmd UTF8String]) == 0)
                        {
                            if(!_initialized)
                            {
                                if([[NSFileManager defaultManager] fileExistsAtPath:@"/Share/Datas.txt"])
                                {
                                    [[NSFileManager defaultManager] removeItemAtPath:@"/Share/Datas.txt" error:&err];
                                }
                            }
                            if(!_shareFolderMounted) self.logMessage = [JKLogMessage msgWithInfo:@"Shared folder is mounted"];
                            _shareFolderMounted = YES;
                        }
                        else
                        {
                            if(!_shareFolderMounted) self.logMessage = [JKLogMessage msgWithInfo:@"Failed to mount shared folder!" withLevel:ML_WARNING];
                            _shareFolderMounted = NO;
                        }
                    }
                    else
                    {
                        if(!_initialized)
                        {
                            if([[NSFileManager defaultManager] fileExistsAtPath:@"/Share/Datas.txt"])
                            {
                                [[NSFileManager defaultManager] removeItemAtPath:@"/Share/Datas.txt" error:&err];
                            }
                        }
                        if(!_initialized || !_shareFolderMounted) self.logMessage = [JKLogMessage msgWithInfo:@"Shared folder is mounted"];
                        _shareFolderMounted = YES;
                    }
                    
                    return YES;
                }
                else
                {
                    if(!_initialized || _winPCReady) self.logMessage = [JKLogMessage msgWithInfo:@"No Connection to WinPC" withLevel:ML_ERROR];
                    _winPCReady = NO;
                    if([[NSFileManager defaultManager] fileExistsAtPath:dirShare])
                    {
                        NSString *cmd = [NSString stringWithFormat:@"rmdir %@", dirShare];
                        system([cmd UTF8String]);
                    }
                    return NO;
                }
            }
            @catch (NSException *exception) {
                self.logMessage =
                    [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"Exception occure!\nException name:%@\nExceptioin reason:%@", exception.name, exception.reason] withLevel:ML_ERROR];
            }
            @finally {
                return _winPCReady;
            }
        }
        else
        {
            return _winPCReady;
        }
    }
}

-(void)testBeginWithParams:(NSDictionary *)paramDic
{
}

-(void)testItem:(JKTestItem *)item withParams:(NSDictionary *)dic
{
//    if([item.device isEqualTo:@"Self"])
//    {
//        SEL selector = NSSelectorFromString(item.function);
//        if([self respondsToSelector:selector])
//        {//执行function
//            self.logMessage = [LogMessage instanceWithMessage:[NSString stringWithFormat:@"Excuting function \"%@\"...", item.function]];
//            NSMutableDictionary *newDic = [dic mutableCopy];
//            [newDic setObject:item forKey:@"Item"];
//            
//            IMP method = [self methodForSelector:selector];
//            void ( *func)(id, SEL, NSDictionary *) = (void *)method;
//            func(self, selector, newDic);
//        }
//        else
//        {//未找到相应Function
//            item.testValue = item.testReturnStr = [[NSString alloc] initWithFormat:@"Unrecognized function \"%@\"", item.function];
//            self.logMessage = [LogMessage instanceWithMessage:[NSString stringWithFormat:@"Unrecognized function \"%@\"", item.function] withLevel:MSG_ERROR];
//            item.testResult = RST_FAIL;
//        }
//    }
}

-(void)testEndWithParams:(NSDictionary *)paramDic
{
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualTo:@"isTesting"])
    {
        BOOL isTesting = [[change objectForKey:@"new"] boolValue];
        if(isTesting)
        {
//            _pointIndex = [SysConfig sharedConfig].currentSpecialPointIndex;
        }
    }
}

@end
