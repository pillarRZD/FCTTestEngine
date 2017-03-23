//
//  SumaryLogPlugin.m
//  X2AX2B
//
//  Created by hotabbit on 14-8-5.
//  Copyright (c) 2014年 hotabbit. All rights reserved.
//

#import "CSVLogDevice.h"
#import "CSVDataLog.h"
#import "AppConfig.h"

@interface CSVLogDevice()
{
    CSVDataLog* _writer;
    NSMutableArray* _itemSet;
}
@end

@implementation CSVLogDevice
{
    BOOL mStopped;
}

- (instancetype) init
{
    if (self = [super init]) {
        _writer = [[CSVDataLog alloc] init];
        _itemSet = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(instancetype)initWithConfig:(NSDictionary *)paramDic
{
    self = [super initWithConfig:paramDic];
    
    if(self)
    {
        _writer = [[CSVDataLog alloc] init];
        _itemSet = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)testBeginWithParams:(NSDictionary *)paramDic
{
    [_itemSet removeAllObjects];
}


-(void)testItem:(JKTestItem *)item withParams:(NSDictionary *)dic
{
    return;
}

-(void)storageDataWithParams:(NSDictionary *)paramDic
{
    NSArray *itemSet = [paramDic objectForKey:@"ItemSet"];
    NSNumber *slotNumber = [paramDic objectForKey:JKPDKEY_DUTINDEX];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString* bundleName = [mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString* marketVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* buildVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString *swVersioin = [NSString stringWithFormat:@"%@.%@", marketVersion, buildVersion];
    
    [self saveSingleCSVFileWithParams:paramDic];
    
    BOOL stepFlag = [[paramDic valueForKeyPath:@"StepFlag"] boolValue];     //手动单步测试时的数据不写入汇总的CSV文件
    if(!stepFlag)
    {
        [self collectResult:itemSet];
        [_writer writeSumary:_itemSet
                SerialNumber:[paramDic objectForKey:@"SN"]
                   FixtureID:[[AppConfig config] valueForKeyPath:@"General.FixtureID"]
                        SLOT:slotNumber
                   Starttime:[[paramDic valueForKey:@"StartTime"] longValue]
                     Endtime:[[paramDic valueForKey:@"EndTime"] longValue]
                 StationName:bundleName
                   SWVersion:swVersioin
                 ProductType:[[AppConfig config] valueForKeyPath:@"ProductType"]];
        
        [_itemSet removeAllObjects];
    }
}

- (void)saveSingleCSVFileWithParams:(NSDictionary *)paramDic
{
//    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray     *itemSet = [paramDic objectForKey:@"ItemSet"];
    NSString    *sn = [paramDic objectForKey:@"SN"];
    
    JKTRESULT   rst = [[paramDic objectForKey:@"Result"] integerValue];
    NSString    *rstString = (rst == TR_PASS) ? @"PASS" : (rst == TR_FAIL) ? @"FAIL" : @"NONE";
    NSString    *fName = [NSString stringWithFormat:@"%@_%@.csv", rstString, sn];
    NSString    *refDir = [paramDic objectForKey:JKPDKEY_LOGDIR];
    NSString    *fPath = [refDir stringByAppendingPathComponent:fName];

    NSMutableString *dataInfo = [NSMutableString string];
    for(JKTestItem *item in itemSet)
    {
        if(item.subItems.count > 0)
        {
            [dataInfo appendString:item.itemName];
            for(JKTestItem *subItem in item.subItems)
            {
                [dataInfo appendFormat:@", %@, %@, %@, %@, %@, %@\r\n"
                 , subItem.itemName
                 , subItem.testControl.enabled ? ((subItem.testResult == TR_PASS) ? @"PASS" : @"FAIL") : @"SKIP"
                 , subItem.testValue
                 , subItem.dataSpec.lowerLimit != JKNoLimit ? [NSString stringWithFormat:@"%.3lf", subItem.dataSpec.lowerLimit] : @"N/A"
                 , subItem.dataSpec.upperLimit != JKNoLimit ? [NSString stringWithFormat:@"%.3lf", subItem.dataSpec.upperLimit] : @"N/A"
                 , subItem.dataSpec.unit];
            }
        }
        else
        {
            [dataInfo appendFormat:@"%@, ----, %@, %@, %@, %@, %@\r\n"
             , item.itemName
             , item.testControl.enabled ? ((item.testResult == TR_PASS) ? @"PASS" : @"FAIL") : @"SKIP"
             , item.testValue
             , item.dataSpec.lowerLimit != JKNoLimit ? [NSString stringWithFormat:@"%.3lf", item.dataSpec.lowerLimit] : @"N/A"
             , item.dataSpec.upperLimit != JKNoLimit ? [NSString stringWithFormat:@"%.3lf", item.dataSpec.upperLimit] : @"N/A"
             , item.dataSpec.unit];
        }
    }
    
    [dataInfo writeToFile:fPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void)collectResult:(NSArray *)testItems
{
    for(JKTestItem *item in testItems)
    {
        if(![item.itemName isEqualTo:@""])
        {
//            if ([item.testValue rangeOfString:@","].length > 0) {
//                item.testValue = [item.testValue stringByReplacingOccurrencesOfString:@"," withString:@" "];
//            }
            [_itemSet addObject:item];
        }
    }
}


-(void)cancel
{
    [_itemSet removeAllObjects];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualTo:@"isTesting"])
    {//TestEngine.isTesting
    }
}

-(instancetype)copy
{
    return self;
}

@end
