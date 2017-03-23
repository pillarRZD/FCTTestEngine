//
//  JKNumberTextField.h
//  JKFramework
//
//  Created by Jack.MT on 16/7/27.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JKNumberFormatter:NSObject

@property(nonatomic) IBInspectable NSString         *numberFormat;

@property(nonatomic) IBInspectable double           minValue;
@property(nonatomic) IBInspectable double           maxValue;

@end
