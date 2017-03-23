//
//  EngineerLogPlugin.m
//  SA-QT0
//
//  Created by Jack.MT on 15/8/1.
//  Copyright (c) 2015年 Jack.MT. All rights reserved.
//

#import "EngineerLogMudole.h"

#define ENGINEER_FOLDER @"/vault/SA-Button_Grape(MT)/engineer_folder/"
#define ENGINEER_PATH   @"/vault/SA-Button_Grape(MT)/flow.txt"

@implementation EngineerLogMudole
{
    BOOL mStopped;
}

- (instancetype) init
{
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
        _logPath = nil;
    }
    
    return self;
}

-(instancetype)initWithParams:(NSDictionary *)paramDic
{
    self = [super initWithParamDic:paramDic];
    
    if(self)
    {
        _fileManager = [NSFileManager defaultManager];
        _logPath = nil;
    }
    
    return self;
}

// 创建flow.txt文件
- (void) initializeWithParameters:(NSArray *)parameters
{
    NSString* introduce = @"//This is a test flow file.\n//It can be use to check the error.\n\n";
    
    if (![_fileManager fileExistsAtPath:ENGINEER_FOLDER]) {
        [_fileManager createDirectoryAtPath:ENGINEER_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![_fileManager fileExistsAtPath:ENGINEER_PATH]) {
        [introduce writeToFile:ENGINEER_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

// 写入数据
- (void) executeWithParameters:(NSArray *)parameters
{
//    [Engine testlog:[[NSString alloc] initWithFormat:@"EngineerPlugin executeWithParameters:"]];
    NSString* selector = parameters[0];
    NSString *sn = parameters[2];
    
    @try {
        NSError *err = nil;
        BOOL success = YES;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        
        [fmt setDateFormat:@"yyyy_MM_dd"];
        NSString *dir = [[NSString alloc] initWithFormat:@"%@/%@", ENGINEER_FOLDER, [fmt stringFromDate:[NSDate date]]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:dir])
        {
//            [Engine testlog:[[NSString alloc] initWithFormat:@"creating directory: %@", dir]];
            success = [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];
            
            if(success)
            {
//                [Engine testlog:[[NSString alloc] initWithFormat:@"directory: %@ created", dir]];
            }else
            {
//                [Engine testlog:[[NSString alloc] initWithFormat:@"create directory: %@ error!", dir]];
            }
        }
        
        [fmt setDateFormat:@"HHmmss"];
        _logPath = (_logPath != nil) ? _logPath : [[NSString alloc] initWithFormat:@"%@/%@_%@.log",  dir, [fmt stringFromDate:[NSDate date]], sn];
        if(![[NSFileManager defaultManager] fileExistsAtPath:_logPath])
        {
//            [Engine testlog:[[NSString alloc] initWithFormat:@"creating file: %@", _logPath]];
            success = [[NSFileManager defaultManager] createFileAtPath:_logPath contents:nil attributes:nil];
            if(success)
            {
//                [Engine testlog:[[NSString alloc] initWithFormat:@"file: %@ created", _logPath]];
            }
            else
            {
//                [Engine testlog:[[NSString alloc] initWithFormat:@"create file: %@ error", _logPath]];
            }
        }
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_logPath];
        if(fileHandle != nil)
        {
            [fileHandle seekToEndOfFile];
            
            if ([selector isEqual:@""])
            {
                JKTestItem* unit = parameters[1];
                
                if (fileHandle != nil) {
                    [fmt setDateFormat:@"[HH:mm:ss]\n"];
                    
                    [fileHandle writeData:[[fmt stringFromDate:[NSDate date]]
                                           dataUsingEncoding:NSUTF8StringEncoding]];
                    [fileHandle writeData:[[NSString stringWithFormat:@"[Send] --> %@\n", unit.operations.lastObject.commAction.command]
                                           dataUsingEncoding:NSUTF8StringEncoding]];
                    [fileHandle writeData:[[NSString stringWithFormat:@"[Revice] <-- %@\n\n", unit.operations.lastObject.orgValue]
                                           dataUsingEncoding:NSUTF8StringEncoding]];
                    [fileHandle closeFile];
                }
            }
            else if ([selector isEqual:@"commit"] || [selector isEqualToString:@"stopped"])
            {
                [fileHandle writeData:[[NSString stringWithFormat:@"%@-----SN:{%@}\n\n",selector, sn]
                                       dataUsingEncoding:NSUTF8StringEncoding]];
                _logPath = nil;
            }
            
            [fileHandle closeFile];
            fileHandle = nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"");
    }
    @finally {
        
    }
    

}

/**************  stoppable implement  ***************/

-(void)setStopped:(BOOL)stopped
{
    mStopped = stopped;
}

-(BOOL)stopped
{
    return mStopped;
}

/****************************************************/

@end
