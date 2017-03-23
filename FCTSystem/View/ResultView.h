//
//  ResultView.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/9/4.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import JKFramework;

@interface ResultView : NSViewController

-(instancetype)initWithDUTIndex:(NSInteger)dutIndex;
-(instancetype)initWithPosition:(NSPoint) position andDUTIndex:(NSInteger)dutIndex;

@property(nonatomic) NSInteger          dutIndex;
@property(nonatomic) BOOL               enabled;
@property(nonatomic) JKTRESULT          result;

@property(nonatomic) NSRect             frame;

@end
