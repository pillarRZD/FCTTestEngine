//
//  TestItem.h
//  Test
//
//  Created by Jack.MT on 16/7/6.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKOperation.h"
#import "JKDataReport.h"
#import "JKTestControl.h"


@interface JKTestItem : NSObject

- (instancetype)initWithParamDic:(NSDictionary *) paramDic;
- (void)reset;

- (JKTRESULT)testWithParamDic:(NSDictionary *) paramDic;

- (void)setEnabled:(BOOL)enabled;

@property(assign) JKTestItem                    *parentItem;

@property NSString                          *itemID;
@property NSString                          *itemName;
@property(nonatomic, readonly) NSString     *itemDescription;

///Array of JKOperation
/** 操作集 */
@property NSArray                                   *operations;
/** 当前TestItem的数据源Operation的索引（0-based Index） */
@property(readonly) NSInteger                       indexOfDataSourceOperation;

@property JKDataReport                              *dataReport;
@property JKTestControl                             *testControl;
@property(nonatomic, readonly, copy) JKSpec         *dataSpec;

///Array of JKTestItem
@property NSArray                                   *subItems;

@property(readonly) NSString                        *originalData;
@property(readonly) NSString                        *testValue;
@property JKTRESULT                                     testResult;
@property(nonatomic, readonly) double                   cycleTime;

@property(nonatomic, readonly) NSDate                   *startTime;
@property(nonatomic, readonly) NSDate                   *endTime;

@property(nonatomic, readonly) NSString                 *testSummary;
@property(nonatomic, readonly) NSString                 *testDetail;
@property(nonatomic, readonly) NSString                 *testNormalInfo;

@end
