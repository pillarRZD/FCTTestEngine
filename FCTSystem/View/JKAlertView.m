//
//  JKAlertView.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/9/3.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "JKAlertView.h"

@interface JKAlertView ()
{
    IBOutlet NSTextView          *_msgShower;
}

@end

@implementation JKAlertView

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

static dispatch_once_t failOpOnceToken;
static NSRegularExpression *failOpRegex;
-(void)setMessage:(NSString *)message
{
    dispatch_once(&failOpOnceToken, ^(){
        NSError *err = nil;
        NSRegularExpressionOptions regexOptions = NSRegularExpressionDotMatchesLineSeparators;
        failOpRegex = [[NSRegularExpression alloc] initWithPattern:@"Operation <([0-9]+)>.+Result: FAIL.+\\^+ ?+\\1 ?+\\^+[^\n]+" options:regexOptions error:&err];
    });
    
    dispatch_block_t setAttrBlock = ^(){
        _msgShower.string = message;
        [_msgShower.textStorage setAttributes:@{NSFontAttributeName:[NSFont fontWithName:@"Arial Bold" size:12]} range:NSMakeRange(0, message.length)];
        
        NSArray *matches = [failOpRegex matchesInString:message options:0 range:NSMakeRange(0, message.length)];
        for(NSTextCheckingResult *rst in matches)
        {
            [_msgShower.textStorage addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:rst.range];
        }
        
        [_msgShower scrollRangeToVisible:NSMakeRange(_msgShower.string.length, 0)];
    };
    
    if([NSThread currentThread].isMainThread)
    {
        setAttrBlock();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), setAttrBlock);
    }
}


@end
