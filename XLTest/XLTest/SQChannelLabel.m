//
//  SQChannelLabel.m
//  SQNewsList
//
//  Created by Franky on 2017/8/22.
//  Copyright © 2017年 MasterKing. All rights reserved.
//

#import "SQChannelLabel.h"

@implementation SQChannelLabel

+ (instancetype)channelLabelWithText:(NSString *)text{
    SQChannelLabel *label = [[SQChannelLabel alloc] init];
    label.userInteractionEnabled = YES;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:label.highlightedFontSize];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:label.normalFontSize];
    return label;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.normalColor = [UIColor blackColor];
        self.highlightedColor = HEX_COLOR(0x73C4F6);
        
        self.normalFontSize = 16;
        self.highlightedFontSize = 17.5;
    }
    return self;
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    self.textColor = normalColor;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    
    CGFloat max = (self.highlightedFontSize * 1.0 / self.normalFontSize) - 1;
    
    self.transform = CGAffineTransformMakeScale(max * scale + 1, max * scale + 1);
    
    // 高亮时的颜色:73C4F6
    // 这个地方要说一下...其实就是简单的y = kx + b,高亮显示的颜色是0.451,0.769,0.965,普通显示的颜色是白色1,1,1;
    // 以red值为例:高亮显示时是0.451 普通状态是1;
    // 即scale == 1时,值为0.451 scale == 0时,值为1;
    //
    // self.textColor = [UIColor colorWithRed:-0.549 * scale + 1 green:-0.231 * scale + 1 blue:-0.035 * scale + 1 alpha:1.000];
    //
    
    
    // k * scale + b
    
    CGFloat normalRed,normalGreen,normalBlue,normalAlpha = CGFLOAT_MIN;
    CGFloat highlightedRed,highlightedGreen,highlightedBlue,highlightedAlpha = CGFLOAT_MIN;
    
    [self.normalColor getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:&normalAlpha];
    [self.highlightedColor getRed:&highlightedRed green:&highlightedGreen blue:&highlightedBlue alpha:&highlightedAlpha];
    
    CGFloat red = ((highlightedRed - normalRed) * scale + normalRed);
    CGFloat green = ((highlightedGreen - normalGreen) * scale + normalGreen);
    CGFloat blue = ((highlightedBlue - normalBlue) * scale + normalBlue);
    CGFloat alpha = ((highlightedAlpha - normalAlpha) * scale + normalAlpha);
    
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.000];
    
    
    
//    UIColor *color = [UIColor brownColor];
//    CGFloat red = CGFLOAT_MIN;
//    CGFloat green = CGFLOAT_MIN;
//    CGFloat blue = CGFLOAT_MIN;
//    CGFloat alpha = CGFLOAT_MIN;
//    [color getRed:&red green:&green blue:&blue alpha:&alpha];
//    NSLog(@"red:%g,green:%g,blue:%g,alpha:%g",red,green,blue,alpha);
}



@end

