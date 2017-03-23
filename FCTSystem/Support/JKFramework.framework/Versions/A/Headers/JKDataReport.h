//
//  DataCollectionConfig.h
//  Test
//
//  Created by Jack.MT on 16/7/7.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPDCAReport.h"

@interface JKDataReport : NSObject

///// PDCA Report
/**
 当前test在PDCA上的名称，如果没有设置（为nil或为空）， 则当前test不上传至PDCA*/
@property(readonly) JKPDCAReport            *pdca;

- (instancetype)initWithParamDic:(NSDictionary *) paramDic;

@end
