//
//  TcpDevice.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/10.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "MainBoard.h"
@import JKFramework;
#import "AppConfig.h"
#import "WaveDisplay.h"

#import <math.h>
#import <Accelerate/Accelerate.h>

#define ZERO_DAQ        0x800000
#define MAX_DAQ         0xFFFFFF
#define BASE_DAQ        0x7FFFFF
#define BASE_VOLTAGE    3.2678

#define ALGORITHM_AMP_MEAN      @"Mean"
#define ALGORITHM_AMP_SP        @"SP"


typedef NS_ENUM(NSInteger, CHANNEL_TYPE)
{
    CHANNEL_LEFT,
    CHANNEL_RIGHT
};

@implementation MainBoard
{
    NSString        *_password;
    double          _checkInterval;
    
    BOOL _exist;
    
    //for PWM
    double                      *_pwmDatas;
    double                      *_ampDatas;
    NSInteger                   _dataCount;
    
    FFTSetupD                   _fftSetup;
    
    double          _baseVoltage;
    double          _stdSquareFreq;
    double          _stdSquareAmp;
    double          _stdSquareDutyCycle;
    double          _stdMeanVolt;
    NSString        *_ampAlgorithm;
    
    double          _meanVolt;

    NSString        *_commandMapFile;
    NSDictionary    *_commandMap;
    
    WaveDisplay     *_timeDomainWaveDisplay;
    WaveDisplay     *_freqDemainWaveDisplay;
}

dispatch_once_t daqInitOnceToken;
static NSMutableDictionary      *checkThreadDictionary;
static NSMutableDictionary      *checkTaskDictionary;
//static NSMutableDictionary      *checkServerIPDictionary;
- (instancetype)initWithConfig:(NSDictionary *)paramDic
{
    self = [super initWithConfig:paramDic];
    
    if(self)
    {
        dispatch_once(&daqInitOnceToken, ^(){
            checkThreadDictionary = [NSMutableDictionary dictionary];
//            checkServerIPDictionary = [NSMutableDictionary dictionary];
        });
        _password       = [paramDic valueForKeyPath:@"Password"];
        
        id value        = [paramDic valueForKeyPath:@"StdSquareFreq"];
        _stdSquareFreq       = value && [value isKindOfClass:NSNumber.class] ? [value doubleValue] : 362;          //默认音频为362K
        value           = [paramDic valueForKeyPath:@"StdSquareAmp"];
        _stdSquareAmp     = value && [value isKindOfClass:NSNumber.class] ? [value doubleValue] : 20;
        value           = [paramDic valueForKeyPath:@"StdSquareDutyCycle"];
        _stdSquareDutyCycle     = value && [value isKindOfClass:NSNumber.class] ? [value doubleValue] : 25;
        value           = [paramDic valueForKeyPath:@"StdMeanVolt"];
        _stdMeanVolt            = value && [value isKindOfClass:NSNumber.class] ? [value doubleValue] : 10;
        value           = [paramDic valueForKeyPath:@"BaseVoltage"];
        _baseVoltage    = value && [value isKindOfClass:NSNumber.class] ? [value doubleValue] : 3.2678;
//        value           = [paramDic valueForKeyPath:@"Buffer.SampleFreq"];
//        _sampleFreq     = value && [value isKindOfClass:NSNumber.class] ? [value doubleValue] : 20000;     //默认采样频率为20000K
//        value           = [paramDic valueForKeyPath:@"Buffer.SampleCount"];
//        _sampleCount     = value && [value isKindOfClass:NSNumber.class] ? [value doubleValue] : 8192;     //默认采样数量为8192
        
        _commandMapFile = [paramDic valueForKeyPath:@"CommandMapFile"];
        NSError *err = nil;
        NSString *cmdMapFile = [NSString stringWithFormat:@"%@/testerconfig/%@", NSHomeDirectory(), _commandMapFile];
        NSData *data = [NSData dataWithContentsOfFile:cmdMapFile];
        _commandMap = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        _daqDataBuffer  = [NSMutableData data];
        
        _checkInterval  = [[paramDic valueForKeyPath:@"CheckInterval"] doubleValue];
        
        _opened = NO;
        
        _timeDomainWaveDisplay      = [[WaveDisplay alloc] initWithLocation:NSMakePoint(350, 500) andTitle:@"Time Domain Wave"];
        _freqDemainWaveDisplay      = [[WaveDisplay alloc] initWithLocation:NSMakePoint(350, 250) andTitle:@"Freq Domain Wave"];
        
        [[[NSThread alloc] initWithTarget:self selector:@selector(runCheckTaskForDevice:) object:self.configName] start];
    }
    
    return self;
}

- (void)runCheckTaskForDevice:(NSString *)devName
{
    if([checkThreadDictionary.allKeys containsObject:devName] == YES)
    {
        NSThread *thread = (NSThread *)[checkThreadDictionary objectForKey:devName];
        [thread cancel];
        while(thread.isExecuting)
        {
            [NSThread sleepForTimeInterval:0.05];
        }
    }
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(checkServer) object:nil];
    [checkThreadDictionary setObject:thread forKey:devName];
    [thread start];
}

- (void)checkServer
{
//    NSString *pPath = _serverIP;
    NSLog(@"[%@]<< Check-Server_Thread(%@) Begin", self.configName, [NSThread currentThread]);
    int retValue;
    while(YES)
    {
        @autoreleasepool {
            NSString *cmd = [NSString stringWithFormat:@"ping -c1 -t1 %@ | grep '1 packets received' > /dev/null", self.serverIP];
            retValue = system([cmd UTF8String]);
        }

        
        BOOL ok = (retValue == 0);
        if(ok)
        {
            if(_exist == NO)
            {
                self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Server{%@:%ld} present", self.configName, self.serverIP, self.serverPort]];
            }
        }
        else
        {
            if(_exist)
            {
                self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] No Route to Server{%@:%ld}", self.configName, self.serverIP, self.serverPort] withLevel:MSG_WARNING];
                [self close];
            }
        }
        
        _exist = ok;
        if(_exist && _opened == NO)
        {
            [self open];
        }
        
        if([NSThread currentThread].cancelled == NO
           && [NSThread mainThread].isExecuting)
        {
            [NSThread sleepForTimeInterval:_checkInterval];
        }
        else
        {
            break;
        }

    }
    NSLog(@"[%@]<< Check-Server_Thread(%@) exit", self.configName, [NSThread currentThread]);
}

- (BOOL)exist
{
    return _exist;
}


- (NSString *)dmm:(NSArray *)args
{
    NSDictionary *kwArgs = [args lastObject];
    NSString *unit = [kwArgs objectForKey:@"unit"];
    return unit;
}

- (NSString *)relay:(NSArray *)args
{
    NSString *relayGroupName = args[0];
    NSString *relayGroupPath = [NSString stringWithFormat:@"relay.%@", relayGroupName];
    NSArray *relaySet = [_commandMap valueForKeyPath:relayGroupPath];
    
    for(NSString *relay in relaySet)
    {
    }
    
    return relayGroupName;
}

- (NSString *)disconnect:(NSArray *)args
{
    return nil;
}


/*********     DAQ Calculation    ********/



#define DISPLAY_DATA_START_INDEX    0
#define MAX_DISPLAY_DATA_COUNT      4096


/********** ^^^^   DAQ Calculation   ^^^^  *********/

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Connected to TCP Server.\nLocal Port: %d",self.configName, sock.localPort]];
    _asyncSocket = sock;
    _tagCounter = -1;
    [_asyncSocket readDataWithTimeout:-1 tag:_tagCounter];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@]<< Received data: %@", self.configName, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
    _daqDataBuffer = [data mutableCopy];
    NSString *rValue = [[NSString alloc] initWithData:[NSData dataWithData:data] encoding:NSUTF8StringEncoding];
    
    _dataCount = 0;
    if(data.length > 0 && _daqFlag)
    {//接受十六进制数据
        NSMutableString *mValue = [[NSMutableString alloc] init];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [_timeDomainWaveDisplay showDatas:NULL length:0];
            [_freqDemainWaveDisplay showDatas:NULL length:0];
        });
        
        Byte *tmp = (Byte *)_daqDataBuffer.bytes;
        _dataCount = _daqDataBuffer.length / 2;
        free(_pwmDatas);
        _pwmDatas = malloc(sizeof(double) * _dataCount);
        
        for(int i=0; i<_dataCount; i++, tmp+=2)
        {
            NSInteger data = (tmp[0] << 8) + tmp[1];
            double voltage = (data - 8192) / 16384.0 * 2 / 0.95;
            _pwmDatas[i] = voltage;
            
            [mValue appendFormat:@"<%d>\t%ld(%X%X)\t%lf\r", i+1, data,tmp[0], tmp[1], _pwmDatas[i]];
        }
        [mValue appendString:@"\n"];
        
        rValue = [NSString stringWithFormat:@"%@Length:%ld(bytes)\r\n", [AppConfig config].debugEnabled ? mValue : @"", _daqDataBuffer.length];
        _daqFlag = NO;
    }

    rValue = [rValue hasSuffix:@"\r\n"] ? rValue : [rValue stringByAppendingString:@"\r\n"];

    self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Received data(tag: %ld)", self.configName, tag]];
    if(tag == -1)
    {//[rValue containsString:@"Please input password:"]
        _tagCounter = 0;

        [sock readDataWithTimeout:-1 tag:-2];
        self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@]>> %@", self.configName, _password]];
        [sock writeData:[_password dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:-2];
    }
    else if(tag == -2)
    {
        if([rValue containsString:@"Sorry"] == NO)
        {
            self.logMessage = [JKLogMessage msgWithInfo:[NSString stringWithFormat:@"[%@] Login successfully!", self.configName]];
            _tagCounter = 0;
            _opened = YES;
        }
    }
    else
    {
        if(tag == _tagCounter-1)
        {//发送命令后syncCounter已经加1，所以这里应该-1
            _retValue = [rValue copy];
            [_synchLock unlock];
        }
        else
        {
            _retValue = nil;
        }
    }
}

@end
