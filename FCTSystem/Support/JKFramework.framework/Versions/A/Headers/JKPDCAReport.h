//
//  JKPDCAReport.h
//  JKFramework
//
//  Created by Jack.MT on 2017/3/6.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKPDCAReport : NSObject

///// PDCA Report
/**
 当前test在PDCA上的名称，如果没有设置（为nil或为空）， 则当前test不上传至PDCA*/
@property(readonly) NSString            *testName;
/**
当前test在PDCA系统中的priority*/
@property(readonly) NSInteger           priority;
/**
 产品Attribute名称，如果当前test的产品Attribute名称没设置（为nil或为空），则当前test不作为产品的Attribute上传至PDCA*/
@property(readonly) NSString            *attributeName;
/**
 当前test的原始数据上传至PDCA时的数据块名称，如果没有设置（为nil或为空）， 则当前test的原始数据不上传至PDCA*/
@property(readonly) NSString            *blobName;

- (instancetype)initWithParamDic:(NSDictionary *) paramDic;

@end
