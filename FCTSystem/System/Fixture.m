//
//  MotionDevice.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/13.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "Fixture.h"
#import <IOKit/usb/IOUSBLib.h>
#import <JKFramework/JKFramework.h>

@implementation Fixture
{
    NSDictionary        *_cmdSet;
    
    NSArray             *_initCmdSet;
    NSArray             *_startCmdSet;
    NSArray             *_startCmdSets;
    NSArray             *_endCmdSet;
    NSDictionary        *_checkDBStartCommandCfg;
}


-(instancetype)initWithConfig:(NSDictionary *)paramDic
{
    self = [super initWithConfig:paramDic];
    
    if(self)
    {
        _cmdSet = [paramDic valueForKeyPath:@"Commands"];
        
        _initCmdSet                 = [paramDic valueForKeyPath:@"Commands.InitCmds"];
        _startCmdSet                = [paramDic valueForKeyPath:@"Commands.StartCmds"];
        _endCmdSet                  = [paramDic valueForKeyPath:@"Commands.EndCmds"];
        _checkDBStartCommandCfg     = [paramDic valueForKeyPath:@"Commands.CheckDBStart"];
        _startCmdSets               = [paramDic valueForKeyPath:@"Commands.StartCmdSets"];
    }
    
    return self;
}

- (BOOL)open
{
    BOOL isSuccess = [super open];
    
    if(isSuccess)
    {
    }
    
    _opened = isSuccess;
    
    return isSuccess;
}

- (void)engage
{
    
}

- (void)disengage
{
    
}

-(NSString *)sendCommand:(NSString *)command withParamDic:(NSDictionary *)paramDic
{
    NSString *err = [super sendCommand:command withParamDic:paramDic];
    
    return err;
}

-(NSString *)readFeedBackWithParamDic:(NSDictionary *)paramDic
{
    JKCommAction    *action = [paramDic valueForKeyPath:@"CommAction"];
    NSString *retValue = nil;
    if(self.opened)
    {
        if(action && action.endMark)
        {
            _serialPort.timeout = action.timeout;
            [_serialPort readToString:action.endMark];
        }
        else
        {
            retValue = [_serialPort readExsiting];
        }

    }
    
    return retValue;
}

-(BOOL)checkDBStart
{
    BOOL isDBPressed = YES;
    
    isDBPressed = [self runCommands:@[_checkDBStartCommandCfg]];
    
    return isDBPressed;
}

- (NSString *)vendor_id:(NSArray *)args
{
    return @"";
}


/**
 This function will be called to check machine state at the start of test*/
- (BOOL)runStartCommands
{
    BOOL isSuccess = YES;
    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Excuting Start-Commands:\n%@", self.configName, _startCmdSet]];
    
    isSuccess = [self runCommands:_startCmdSet];
    
    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Excuted Start-Commands", self.configName]];
    
    return isSuccess;
}

- (BOOL)runStartCommandsForGroup:(NSNumber *)groupIndex
{
    BOOL isSuccess = YES;
    NSInteger gIdx = [groupIndex integerValue];
    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Excuting Start-Commands(Group%ld):\n%@", self.configName, gIdx, _startCmdSets[gIdx-1]]];
    
    isSuccess = [self runCommands:_startCmdSets[gIdx-1]];
    
    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Excuted Start-Commands(Group%ld)", self.configName, gIdx]];
    
    return isSuccess;
}

/**
 This function will be called to do clear-work*/
- (BOOL)runEndCommands
{
    BOOL isSuccess = YES;
    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Excuting End-Commands:\n%@", self.configName, _startCmdSet]];
    
    isSuccess = [self runCommands:_endCmdSet];
    
    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Excuted End-Commands", self.configName]];
    
    return isSuccess;
}

-(BOOL)runCommands:(NSArray *)cmdSet
{
    BOOL isSuccess = YES;
    
    if(self.opened == NO)
    {
        [self open];
    }

    for(NSDictionary *cmdCfg in cmdSet)
    {
        if(self.opened)
        {
            if([cmdCfg valueForKeyPath:@"Command"])
            {
                self.logMessage = [JKLogMessage msgWithInfo:
                                   [NSString stringWithFormat:@"[%@]>> %@", self.configName,[cmdCfg valueForKeyPath:@"Command"]]];
                [self sendCommand:[cmdCfg valueForKeyPath:@"Command"] withParamDic:nil];
            }
            
            NSString *retValue = nil;
            double  readTimeout = [[cmdCfg valueForKeyPath:@"Timeout"] doubleValue];
            
            _serialPort.timeout = readTimeout;
            NSString *endMark = [cmdCfg valueForKeyPath:@"EndMark"];
            endMark = [endMark stringByRestoreInvisibleCharacter];
            retValue = [_serialPort readToString:endMark];
            
            self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@]<< %@", self.configName, retValue]];
            
            NSString *expectValue = [cmdCfg valueForKeyPath:@"ExpectValue"];

            isSuccess &= (retValue != nil
                          && [retValue containsString:expectValue]);
        }
        else
        {
            self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@]<< device is not opened!", self.configName]];
            isSuccess = NO;
        }
        
        if(isSuccess == NO)
        {
            break;
        }
    }
    
    return isSuccess;
}


@end
