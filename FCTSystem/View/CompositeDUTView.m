//
//  CompositeDUTView.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/9/4.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "CompositeDUTView.h"
#import "TestEngine.h"
#import "ResultView.h"
#import <Cocoa/Cocoa.h>

@interface CompositeDUTView ()

@end

@implementation CompositeDUTView
{
    IBOutlet NSOutlineView      *_ovItemSetShower;
    IBOutlet NSScrollView       *_rstScroller;
    
    NSInteger               _dutCount;
    NSInteger               _maxRstCountInRow;
    
}

-(instancetype)initWithFrame:(NSRect)frame withDUTCount:(NSInteger) dutCount
{
    self = [super init];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
        self.view.frame = frame;
        
        _maxRstCountInRow = 4;
        
        [self layout];
    }
    
    return self;
}

-(void)layout
{
    NSInteger rstRowCount = ceil(_dutCount*1.0 / _maxRstCountInRow);
    NSRect viewFrame = self.view.frame;
    ResultView *rvTmp  =[[ResultView alloc] initWithDUTIndex:-1];
    
    double ySpace = 10, yMargin = 5, xMargin = 4;
    NSSize containerSize = NSMakeSize(NSWidth(viewFrame), yMargin*2 + ySpace*(rstRowCount-1) + NSHeight(rvTmp.view.frame)*rstRowCount);
    
    NSView *containerView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, containerSize.width, containerSize.height)];

    //0...rstRowCount-1行布局
    NSInteger dutIndex = 1;
    double xSpace = (NSWidth(viewFrame) - NSWidth(rvTmp.view.frame)*_maxRstCountInRow - 2*xMargin) / (_maxRstCountInRow-1);
    for(int i=1; i<rstRowCount; i++)
    {
        double yPos = containerSize.height - yMargin - NSHeight(rvTmp.view.frame)*i;
        for(int j=0; j<_maxRstCountInRow; j++)
        {
            double xPos = xMargin + (NSWidth(rvTmp.view.frame) + xSpace)*j;
            ResultView *rv = [[ResultView alloc] initWithPosition:NSMakePoint(xPos, yPos) andDUTIndex:dutIndex++];
            
            [containerView addSubview:rv.view];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
