//
//  JKNumberTextField.h
//  JKFramework
//
//  Created by Jack.MT on 16/7/28.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

IB_DESIGNABLE
@interface JKNumberTextField : NSTextField<NSTextFieldDelegate>

@property(nonatomic) IBInspectable double       minimum;
@property(nonatomic) IBInspectable double       maxinum;

@end
