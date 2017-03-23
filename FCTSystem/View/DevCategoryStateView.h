//
//  DevCategoryStateView.h
//  FCT(B431)
//
//  Created by Jack.MT on 2/7/17.
//  Copyright © 2017 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DevCategoryStateView : NSViewController

- (instancetype)initWithCategory:(NSString *)category;
- (instancetype)initWithCategory:(NSString *)category andPanelWidth:(CGFloat)panelWidth;

- (void)checkStatus;

@property NSString          *devCategory;

@end
