//
//  JKView.h
//  JKFramework
//
//  Created by Jack.MT on 16/7/19.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol JKMouseEventDelegate

- (void)mouseDown:(NSEvent *)theEvent;
- (void)rightMouseDown:(NSEvent *)theEvent;
- (void)otherMouseDown:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
- (void)rightMouseUp:(NSEvent *)theEvent;
- (void)otherMouseUp:(NSEvent *)theEvent;

@end

// 在定义类的前面加上IB_DESIGNABLE宏,确保该控件在xib或storyboard上可以实时渲染
IB_DESIGNABLE
@interface JKView : NSView<NSCopying>

@property(nonatomic, strong) IBInspectable NSColor *backgroundColor;        //IBInspectable 修饰的属性可以在 xib或storyboard上显示

@property(nonatomic) id                 delegate;

@end
