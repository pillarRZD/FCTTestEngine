//
//  WaveDisplay.h
//  FCT(B431)
//
//  Created by Jack.MT on 2/17/17.
//  Copyright © 2017 Jack.MT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WaveDisplay : NSWindowController

@property(nonatomic) NSPoint            location;
@property(nonatomic) NSString           *title;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithLocation:(NSPoint)location andTitle:(NSString *)title;

- (void)showDatas:(double *)datas length:(NSInteger)length;
- (void)addTag:(NSString *)tag atPosition:(NSPoint)position;

@end
