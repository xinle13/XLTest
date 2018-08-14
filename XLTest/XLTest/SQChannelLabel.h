//
//  SQChannelLabel.h
//  SQNewsList
//
//  Created by Franky on 2017/8/22.
//  Copyright © 2017年 MasterKing. All rights reserved.
//

#import <UIKit/UIKit.h>

//static CGFloat const SQChannelLabelBigFontSize = 18;
//static CGFloat const SQChannelLabelSmallFontSize = 16;

@interface SQChannelLabel : UILabel

+ (instancetype)channelLabelWithText:(NSString *)text;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic, assign) CGFloat normalFontSize;
@property (nonatomic, assign) CGFloat highlightedFontSize;

@end
