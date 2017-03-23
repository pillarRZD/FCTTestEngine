//
//  WaveDisplay.m
//  FCT(B431)
//
//  Created by Jack.MT on 2/17/17.
//  Copyright © 2017 Jack.MT. All rights reserved.
//

#import "WaveDisplay.h"
#import <JKFramework/JKFramework.h>

@interface WaveDisplay ()
{
    IBOutlet JKChart    *_wavePanel;
}

@end

@implementation WaveDisplay

- (instancetype)init
{
    return [self initWithTitle:@"Wave"];
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithLocation:NSMakePoint(-1, -1) andTitle:title];
}

- (instancetype)initWithLocation:(NSPoint)location andTitle:(NSString *)title
{
    self = [super init];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
        self.window.title = title;
        if(location.x >=0 && location.y >=0)
        {
//            NSRect newFrame = NSMakeRect(location.x, location.y, NSWidth(self.window.frame), NSHeight(self.window.frame));
            [self.window setFrameOrigin:location];
        }
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSPoint)location
{
    return self.window.frame.origin;
}

- (void)setLocation:(NSPoint)location
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.window setFrameOrigin:location];
    });
}

- (NSString *)title
{
    return self.window.title;
}

- (void)setTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        self.window.title = title;
    });
}

- (void)showDatas:(double *)datas length:(NSInteger)length
{
    [_wavePanel clearTag];
    [_wavePanel addTag:[NSString stringWithFormat:@"%ld", length] withColor:[NSColor greenColor] atPosition:NSMakePoint(960, 120)];
    [_wavePanel showDatas:datas length:length];
}

- (void)addTag:(NSString *)tag atPosition:(NSPoint)position
{
    [_wavePanel addTag:tag atPosition:position];
}

@end
