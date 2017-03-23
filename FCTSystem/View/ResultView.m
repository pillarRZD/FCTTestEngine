//
//  ResultView.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/9/4.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "ResultView.h"
#import "AppConfig.h"

@interface ResultView ()

@end

@implementation ResultView
{
    IBOutlet NSTextField        *_tfDUTIndex;
    IBOutlet NSButton           *_btEnabled;
    IBOutlet NSImageView        *_imgResult;
}

-(instancetype)init
{
    return [self initWithPosition:NSMakePoint(0, 0) andDUTIndex:-1];
}

-(instancetype)initWithDUTIndex:(NSInteger)dutIndex
{
    return [self initWithPosition:NSMakePoint(0, 0) andDUTIndex:dutIndex];
}

static NSDictionary<NSNumber *, __kindof NSImage *> *globalRstImageDic;
static dispatch_once_t  token;
-(instancetype)initWithPosition:(NSPoint)position andDUTIndex:(NSInteger)dutIndex
{
    self = [super init];
    
    if(self)
    {
        dispatch_once(&token, ^(){
            globalRstImageDic = @{[NSNumber numberWithInteger:TR_PASS]:[AppConfig config].imgPass,
                                  [NSNumber numberWithInteger:TR_FAIL]:[AppConfig config].imgFail,
                                  [NSNumber numberWithInteger:TR_COMM_ERR]:[AppConfig config].imgCommErr,
                                  [NSNumber numberWithInteger:TR_FATAL_ERR]:[AppConfig config].imgFatalErr,
                                  [NSNumber numberWithInteger:TR_ABORT4FAIL]:[AppConfig config].imgFail,
                                  [NSNumber numberWithInteger:TR_ABORT4OP]:[AppConfig config].imgAbort,
                                  [NSNumber numberWithInteger:TR_NONE]:[AppConfig config].imgNone};
        });
        
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
        self.view.frame = NSMakeRect(position.x, position.y, NSWidth(self.view.frame), NSHeight(self.view.frame));
    }
    
    return self;
}

-(void)setDutIndex:(NSInteger)dutIndex
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        _tfDUTIndex.stringValue = [NSString stringWithFormat:@"#%ld", dutIndex];
    });
}

-(NSInteger)dutIndex
{
    NSInteger dutIndex = [[_tfDUTIndex.stringValue substringFromIndex:1] integerValue];
    
    return dutIndex;
}

-(void)setEnabled:(BOOL)enabled
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        _btEnabled.enabled = enabled;
    });
}

-(BOOL)enabled
{
    return _btEnabled.state;
}

-(void)setResult:(JKTRESULT)result
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        _imgResult.image = [globalRstImageDic objectForKey:[NSNumber numberWithInteger:result]];
    });
}

- (NSRect)frame
{
    return self.view.frame;
}

- (void)setFrame:(NSRect)frame
{
    self.view.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
