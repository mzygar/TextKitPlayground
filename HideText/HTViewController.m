//
//  HTViewController.m
//  HideText
//
//  Created by Michal Zygar on 11.10.2013.
//  Copyright (c) 2013 Michal Zygar. All rights reserved.
//

#import "HTViewController.h"

@interface HTViewController ()<NSLayoutManagerDelegate>
{
    NSLayoutManager* _layoutManager;
    BOOL _shouldDisplay;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _layoutManager=self.textView.layoutManager;
    [_layoutManager setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hideText:(id)sender {
    _shouldDisplay=!_shouldDisplay;
    if(!_shouldDisplay)
    {
        NSTextAttachment* att=[[NSTextAttachment alloc] init];
        att.image=[UIImage imageNamed:@"dot.png"];
        NSAttributedString* astring=[NSAttributedString attributedStringWithAttachment:att];
        [self.textView.textStorage insertAttributedString:astring atIndex:0];
    }else
    {
        [self.textView.textStorage deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    [_layoutManager invalidateDisplayForCharacterRange:NSMakeRange(0, 20)];
    [_layoutManager ensureGlyphsForCharacterRange:NSMakeRange(0, 20)];
    [[self.textView textStorage] edited:NSTextStorageEditedCharacters range:NSMakeRange(0, 20) changeInLength:0];
    [self.textView setNeedsDisplay];
}

-(NSUInteger)layoutManager:(NSLayoutManager *)layoutManager
      shouldGenerateGlyphs:(const CGGlyph *)glyphs
                properties:(const NSGlyphProperty *)props
          characterIndexes:(const NSUInteger *)charIndexes
                      font:(UIFont *)aFont forGlyphRange:(NSRange)glyphRange
{
    NSRange range=NSMakeRange(*charIndexes,glyphRange.length-1);
    int BUFFER_LEN=1000;
    CGGlyph glyphBuffer[BUFFER_LEN];
    NSGlyphProperty propBuffer[BUFFER_LEN];
    NSUInteger index;
    
    NSRange targetRange=NSMakeRange(0, 20);
    
    range=NSMakeRange(0, 0);
    for (index=0; index<glyphRange.length; index++) {
        if (NSLocationInRange(charIndexes[index], targetRange)) {
            if (index>0 && range.length==0) {
                [layoutManager setGlyphs:glyphs properties:props characterIndexes:charIndexes font:aFont forGlyphRange:NSMakeRange(glyphRange.location, index)];
            }
            
            if (range.length==BUFFER_LEN) {
                
                [layoutManager setGlyphs:glyphBuffer properties:propBuffer characterIndexes:charIndexes+range.location font:aFont forGlyphRange:NSMakeRange(glyphRange.location+range.location, range.length)];
                range.length=0;
            }
            if (range.length==0) {
                range.location=index;
            }
            

            if (!_shouldDisplay) {
                glyphBuffer[range.length]=kCGFontIndexInvalid;
                propBuffer[range.length]=NSGlyphPropertyNull;
            }else
            {
                glyphBuffer[range.length]=glyphs[range.length];
                propBuffer[range.length]=props[range.length];
            }

            ++range.length;
            
            
        }else if(charIndexes[index]>=NSMaxRange(targetRange))
        {
            break;
        }
        
    }
    
    if (range.length>0) {
        [layoutManager setGlyphs:glyphBuffer properties:propBuffer characterIndexes:charIndexes+range.location font:aFont forGlyphRange:NSMakeRange(glyphRange.location+range.location, range.length)];
        
    }
    
    if (glyphRange.length-index>0) {
        [layoutManager setGlyphs:glyphs+index properties:props+index characterIndexes:charIndexes+index font:aFont forGlyphRange:NSMakeRange(glyphRange.location+index, glyphRange.length-index)];
    }
    return glyphRange.length;
}

@end
