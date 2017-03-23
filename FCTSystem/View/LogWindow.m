//
//  LogWindow.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/3.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "LogWindow.h"
@import JKFramework;

@interface LogWindow ()
{
    IBOutlet JKChart                    *_waveChart;
    
    IBOutlet JKMessageViewController    *_logShowerGeneral;
    IBOutlet JKMessageViewController    *_logShower1;
    IBOutlet JKMessageViewController    *_logShower2;
    IBOutlet JKMessageViewController    *_logShower3;
    IBOutlet JKMessageViewController    *_logShower4;
    
    NSArray *_logShowerSet;
}
@end

@implementation LogWindow

static NSRegularExpression *regex;
static dispatch_once_t token;
-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
//        [_logShower setColor:[NSColor brownColor] forLevel:MSG_NORMAl];
        [JKAppConfig addBufferValue:_waveChart forKeyPath:@"WaveChart"];
        _logShowerSet = @[_logShowerGeneral,_logShower1, _logShower2, _logShower3, _logShower4];
        for(JKMessageViewController *shower in _logShowerSet)
        {
            [shower setColor:[NSColor brownColor] forLevel:MSG_NORMAl];
        }
        
        dispatch_once(&token, ^(){
            NSError *err = nil;
            regex = [[NSRegularExpression alloc] initWithPattern:@"\\[[0-9A-Za-z_]+#([0-9]+)\\]" options:0 error:&err];
//            NSLog(@"%@", err);
        });
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)showLog:(JKLogMessage *)logMessage
{
    int index = 0;
    NSTextCheckingResult *result = [regex firstMatchInString:logMessage.message options:0 range:NSMakeRange(0, logMessage.message.length)];
    if(result && result.range.location != NSNotFound)
    {
        index = [logMessage.message substringWithRange:[result rangeAtIndex:1]].intValue;
    }
    index = index < _logShowerSet.count ? index : 0;
    
    JKMessageViewController *shower = _logShowerSet[index];
    [shower showLogMessage:logMessage];

}

- (void)clear
{
//    for(JKMessageViewController *shower in _logShowerSet)
//    {
////        [shower clear];
//    }
}

-(IBAction)close:(id)sender
{
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    [self.window close];
}

@end
