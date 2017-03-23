//
//  SumaryLog.h
//  X2AX2B
//
//  Created by hotabbit on 14-8-5.
//  Copyright (c) 2014年 hotabbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVDataLog : NSObject

-(instancetype)initWithDataDir:(NSString *)dirPath;

- (void) createCsvWithTitle:(NSArray *) testItems
            withStationName:(NSString *) stationName
            swVersion:(NSString *) swVersion
            fixtureID:(NSString *) fixtureID
            productType:(NSString *) productType;
- (void) writeSumary:(NSArray *)testItems
        SerialNumber:(NSString *)sn
           FixtureID:(NSString *)fixtrueID
                SLOT:(NSNumber *)slotNumber
           Starttime:(time_t)startTime
             Endtime:(time_t)endTime
         StationName:(NSString *)stationName
           SWVersion:(NSString *)swVersion
         ProductType:(NSString *)productType;

@end
