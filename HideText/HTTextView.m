//
//  HTTextView.m
//  HideText
//
//  Created by Michal Zygar on 11.10.2013.
//  Copyright (c) 2013 Michal Zygar. All rights reserved.
//

#import "HTTextView.h"

@implementation HTTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat fraction;
    UITouch* touch=[[event allTouches] anyObject];
    CGPoint point=[touch locationInView:self];
    if (touch.phase==UITouchPhaseEnded) {
        
    }
    NSUInteger index=[self.layoutManager characterIndexForPoint:point inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:&fraction];
    if ([self.textStorage.string characterAtIndex:index]==NSAttachmentCharacter) {
        NSLog(@"you tapped attachment");
    }
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super pointInside:point withEvent:event];
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    
    return [super hitTest:point withEvent:event];
}
@end
