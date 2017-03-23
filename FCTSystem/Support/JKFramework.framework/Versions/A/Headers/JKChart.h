//
//  JKChart.h
//  JKFramework
//
//  Created by Jack.MT on 9/13/16.
//  Copyright © 2016 Jack.MT. All rights reserved.
//

#import <JKFramework/JKFramework.h>

IB_DESIGNABLE
@interface JKChart : JKView

@property(nonatomic) IBInspectable double       xMargin;
@property(nonatomic) IBInspectable double       yMargin;
@property(nonatomic) IBInspectable NSColor      *lineColor;
@property(nonatomic) IBInspectable NSColor      *axisColor;

- (void)showDatas:(double *)datas length:(long)dataLength;
- (void)addTag:(NSString *)tag atPosition:(NSPoint)location;
- (void)addTag:(NSString *)tag withColor:(NSColor *)tagColor atPosition:(NSPoint)location;
- (void)clearTag;
- (void)refresh;

@end


@interface JKChartTag : NSObject

+ (instancetype)tagWithString:(NSString *)tag withColor:(NSColor *)color atPosition:(NSPoint)location;

@property NSString      *tag;
@property NSPoint       location;
@property NSColor       *color;

@end
