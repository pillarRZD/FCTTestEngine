//
//  SumaryLog.m
//  X2AX2B
//
//  Created by hotabbit on 14-8-5.
//  Copyright (c) 2014年 hotabbit. All rights reserved.
//

#import "CSVDataLog.h"
#import "AppConfig.h"

@import JKFramework;

#define SUMARY_LOG  @"/vault/SA-Button_Grape(MT)/Data_Log/DataLog.csv"

@implementation CSVDataLog
{
    NSString        *_dirPath;
    NSString* _csvDataLog;
    BOOL mStopped;
}

static NSLock           *sycLock;
static dispatch_once_t  initToken;
- (instancetype) init
{
//    NSString *swName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    return [self initWithDataDir:[NSString stringWithFormat:@"%@/CSV_Datas", [AppConfig config].rootDataDirectory]];
}

- (instancetype) initWithDataDir:(NSString *)dirPath
{
    self = [super init];
    
    if(self)
    {
        dispatch_once(&initToken, ^(){
            sycLock = [[NSLock alloc] init];
        });
        _dirPath = dirPath;
        [[NSFileManager defaultManager] createDirectoryAtPath:_dirPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return self;
}

/**
 创建CSV文件，若csv文件已存在则不进行任何操作*/
- (void) createCsvWithTitle:(NSArray *)testItems
            withStationName:(NSString *)stationName
                  swVersion:(NSString *)version
                  fixtureID:(NSString *)fixtureID
                productType:(NSString *)productType
{
    NSDate *date = [NSDate date];
    NSString *dateFormat = @"yyyy_MM_dd";
    
    NSString *swName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    if (productType) {
        _csvDataLog = [_dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%@.csv", swName, [date stringWithFormat:dateFormat ], productType]];
    }
    else {
        _csvDataLog = [_dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_ALL.csv", swName, [date stringWithFormat:dateFormat ]]];
    }
    
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:_csvDataLog])
    {
        NSString *dir = [_csvDataLog stringByDeletingLastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:[_csvDataLog stringByDeletingLastPathComponent]] == NO)
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    
        NSMutableString* titleStr = [[NSMutableString alloc] init];
        [titleStr appendFormat:@"%@_%@,Version:%@,FixtureID:%@\r\n", stationName, productType ? productType : @"", version, fixtureID];
        
        NSMutableString* lineNameStr   = [[NSMutableString alloc] initWithString: @",SeiralNumber,Test Result,List of Failing Tests,Start Time,End Time,SLOT#,"];
        NSString* upperLimitStr = @"Upper limit,,,,,,,";
        NSString* lowerLimitStr = @"Lower limit,,,,,,,";
        NSString* unitstr       = @"Unit,,,,,,,";
        
        @try {
            for(JKTestItem* item in testItems)
            {
                if (item.itemName == nil || [item.itemName isEqual:@""] || item.testControl.enabled == NO) {
                    continue;
                }
            
                if (![item.itemName isEqual:@""])
                {
                    if(item.subItems.count > 0)
                    {
                        for(JKTestItem *subItem in item.subItems)
                        {
                            [lineNameStr appendFormat:@"%@,", subItem.itemName];
                            if (subItem.dataSpec.upperLimit == JKNoLimit
                                && subItem.dataSpec.lowerLimit == JKNoLimit)
                            {
                                upperLimitStr = [upperLimitStr stringByAppendingString:@"N/A,"];
                                lowerLimitStr = [lowerLimitStr stringByAppendingString:@"N/A,"];
                                unitstr       = [unitstr stringByAppendingString:@"N/A,"];
                            }
                            else {
                                upperLimitStr = [upperLimitStr stringByAppendingFormat:@"%.3lf,", subItem.dataSpec.upperLimit];
                                lowerLimitStr = [lowerLimitStr stringByAppendingFormat:@"%.3lf,", subItem.dataSpec.lowerLimit];
                                unitstr       = [unitstr stringByAppendingFormat:@"%@,", subItem.dataSpec.unit];
                            }
                        }
                    }
                    else
                    {
                        [lineNameStr appendFormat:@"%@,", item.itemName];
                        if (item.dataSpec.upperLimit == JKNoLimit
                            && item.dataSpec.lowerLimit == JKNoLimit)
                        {
                            upperLimitStr = [upperLimitStr stringByAppendingString:@"N/A,"];
                            lowerLimitStr = [lowerLimitStr stringByAppendingString:@"N/A,"];
                            unitstr       = [unitstr stringByAppendingString:@"N/A,"];
                        }
                        else {
                            upperLimitStr = [upperLimitStr stringByAppendingFormat:@"%.6lf,", item.dataSpec.upperLimit];
                            lowerLimitStr = [lowerLimitStr stringByAppendingFormat:@"%.6lf,", item.dataSpec.lowerLimit];
                            unitstr       = [unitstr stringByAppendingFormat:@"%@,", item.dataSpec.unit];
                        }
                    }
                }
            }
            
            [titleStr appendFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n", lineNameStr, upperLimitStr, lowerLimitStr, unitstr];
            
            NSError* error;
            [titleStr writeToFile:_csvDataLog atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if (error != nil && ![error isEqual:@""]) {
                @throw [[NSException alloc] initWithName:@"CSV Error" reason:error.description userInfo:nil];
            }

        }
        @catch (NSException *exception) {
        }
    }
}

// 添加测试数据至SumaryLog.csv文件
- (void) writeSumary:(NSArray *)testItems
        SerialNumber:(NSString *)sn
           FixtureID:(NSString *)fixtrueID
                SLOT:(NSNumber *)slotNumber
           Starttime:(time_t)startTime
             Endtime:(time_t)endTime
         StationName:(NSString *)stationName
           SWVersion:(NSString *)swVersion
         ProductType:(NSString *)productType
{
    [sycLock lock];
    
    [self createCsvWithTitle:testItems
             withStationName:stationName
                   swVersion:swVersion
                   fixtureID:fixtrueID
                 productType:productType];
    
    BOOL flagResult = YES;
    NSMutableString* sumaryData = [[NSMutableString alloc] initWithFormat:@",%@",sn];
    NSMutableString* tmpData = [[NSMutableString alloc] init];
    NSMutableString* failStr = [[NSMutableString alloc] init];
    
    for(JKTestItem* item in testItems)
    {
        if (item.itemName == nil || [item.itemName isEqual:@""] || item.testControl.enabled == NO) {      // 过滤掉无测试名的项
            continue;
        }
        
        if(item.subItems.count > 0)
        {
            for(JKTestItem *subItem in item.subItems)
            {
                [self appendItemInfo:subItem toDataString:tmpData andFailString:failStr];
                flagResult &= item.testResult;
            }
        }
        else
        {
            [self appendItemInfo:item toDataString:tmpData andFailString:failStr];
            flagResult &= item.testResult;
        }
    }
    
    [sumaryData appendFormat:@",%@,%@,%@,%@,%@%@\n", flagResult ? @"PASS" : @"FAIL",
     failStr, [CSVDataLog gettime:startTime], [CSVDataLog gettime:endTime], slotNumber, tmpData];
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:_csvDataLog];
    
    if (fileHandle != nil) {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[sumaryData dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    [sycLock unlock];
}

- (void)appendItemInfo:(JKTestItem *)item toDataString:(NSMutableString *)dataString andFailString:(NSMutableString *)failString
{
    NSString* rst = [[[item.testValue stringByReplacingOccurrencesOfString:@"," withString:@" "]
                      stringByReplacingOccurrencesOfString:@"\n" withString:@"/ "]
                     stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if(rst.length > 50)
    {
        rst = item.testResult == TR_PASS ? @"PASS" : @"FAIL";
    }
    
    if (rst == nil || [rst isEqual:@""]) {
        rst = (item.testResult != TR_NONE) ? @"Null" : @"Untested";
    }
    
    [dataString appendFormat:@",%@", rst];
    
    if (item.testResult == TR_FAIL) {
        [failString appendFormat:@" & %@", item.itemName];
    }
}

+ (NSString *) gettime:(time_t)time
{
    struct tm* tmStrct = localtime(&time);
    NSString *strTime = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",
                        (tmStrct->tm_year + 1900), (tmStrct->tm_mon + 1), tmStrct->tm_mday,
                        tmStrct->tm_hour, tmStrct->tm_min, tmStrct->tm_sec];
    return strTime;
}

+ (NSString *) getFailStr:(NSArray *)failItems
{
    NSMutableString* failStr = [[NSMutableString alloc] initWithString:failItems[0]];
    
    for (int i = 1; i < failItems.count; i++) {
        [failStr appendFormat:@" & %@", failItems[i]];
    }
    
    return failStr;
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
