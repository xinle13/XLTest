//
//  UILabel+TextWidhtHeight.m
//  XLApp
//
//  Created by 辛乐 on 16/9/6.
//  Copyright © 2016年 辛乐. All rights reserved.
//

#import "UILabel+TextWidhtHeight.h"

@implementation UILabel (TextWidhtHeight)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

+ (CGFloat)getMustableAttributedHeightByWidth:(CGFloat)width title:(NSMutableAttributedString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.attributedText = title;
    label.numberOfLines = 0;
    label.font = font;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

@end
