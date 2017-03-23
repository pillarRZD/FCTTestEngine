//
//  AppDevice.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/9/9.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "AppDevice.h"

#import "../Support/IPSFCPost_API.h"
//#import "JKCommAction.h"

typedef struct QRStruct QRStruct;

@implementation AppDevice

#define KEY_BUILD_EVENT     @"BuildEvent"
#define KEY_BUILD_CONFIG    @"BuildConfig"
#define KEY_SBUILD          @"SBuild"

-(NSString *)mlsSN:(NSDictionary *)paramDic
{
    NSString *mlbSN = nil;
    
    mlbSN = [paramDic objectForKey:JKPDKEY_SN];
    
    return mlbSN;
}

-(NSString *)buildEvent:(NSDictionary *)paramDic
{
    NSString *buildEvent = nil;
    
    
    
    return buildEvent;
}

-(NSString *)buildConfig:(NSDictionary *)paramDic
{
    NSString *buildConfig = nil;
    
    return buildConfig;
}

-(NSString *)s_build:(NSDictionary *)paramDic
{
    NSString *s_build = nil;
    
    return s_build;
}


-(NSString *)queryValueForKey:(char *)key withSN:(NSString *) sn
{
    QRStruct *qrStruct[1];
    qrStruct[0] = (QRStruct *)malloc(sizeof(QRStruct));
    if(qrStruct[0] != nil)
    {
        (*qrStruct[0]).Qkey = key;
        (*qrStruct[0]).Qval = (char *)malloc(sizeof(char)*1024);
    }
    
    SFCQueryRecord([sn UTF8String], qrStruct, 1);
    [NSThread sleepForTimeInterval:0.5];
    NSString *value = [[NSString alloc] initWithUTF8String:(*qrStruct[0]).Qval];
    
    free((*qrStruct[0]).Qval);
    free(qrStruct[0]);
    
    return value;
}

@end
