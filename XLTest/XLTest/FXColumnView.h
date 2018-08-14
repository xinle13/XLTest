//
//  FXColumnView.h
//  ZJNews
//
//  Created by admin on 31/01/2018.
//  Copyright © 2018 Bella. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 栏目视图
 */
@interface FXColumnView : UIView

/**
 栏目数组,需要传一个字符串的数组
 */
@property (nonatomic, strong) NSArray *columns;

@property (nonatomic, strong) NSMutableArray *columnCenterArr;

@property (nonatomic, strong) NSMutableArray *columnWidthArr;

@property (nonatomic, strong) NSMutableArray *columnLabelArr;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *indicatorLine;

@property (nonatomic, assign) CGFloat columnHeight;

/** 每个栏目Label之间的间距 默认为 20*/
@property (nonatomic, assign) CGFloat margin;

/** 距离左右两边的间距 默认为 20*/
@property (nonatomic, assign) CGFloat boundaryMargin;

@property (nonatomic, strong) UIColor *labelNormalColor;

@property (nonatomic, strong) UIColor *labelHighlightedColor;

@property (nonatomic, assign) CGFloat labelNormalFontSize;

@property (nonatomic, assign) CGFloat labelHighlightedFontSize;

/** 当所有栏目所在的ScrollView的contentSize.width小于自身宽度时,是否平均分布每个栏目视图---默认为NO*/
@property (nonatomic, assign) BOOL isDivideEquallyWhenContentSizeWidthLessScreenWidth;
/** 当所有栏目所在的ScrollView的contentSize.width小于自身宽度时,在不平均分布的情况下,是否居中排布*/
@property (nonatomic, assign) BOOL isMiddle;

@property (nonatomic, copy) void (^labelTapped)(NSUInteger index);

@property (nonatomic, copy) void (^indicatorLineGetFrame)(UIView *);

@property (nonatomic, assign) CGSize intrinsicContentSize;

@end
