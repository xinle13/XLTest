//
//  FXColumnView.m
//  ZJNews
//
//  Created by admin on 31/01/2018.
//  Copyright © 2018 Bella. All rights reserved.
//

#import "FXColumnView.h"
#import "SQChannelLabel.h"

@interface FXColumnView ()

@end

@implementation FXColumnView

//- (void)didMoveToSuperview{
//    self.backgroundColor = self.superview.backgroundColor;
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.columnLabelArr.count > 0) {

        // 为了解决在iOS10上,导航控制器push的时候也会调用这个view的layoutSubview方法
        NSUInteger index = -1;
        for (SQChannelLabel *lbl in self.columnLabelArr) {
            if (lbl.scale == 1.0) {
                index = [self.columnLabelArr indexOfObject:lbl];
                break;
            }
        }
        if (index == -1) {
            return;
        }
        
        SQChannelLabel *label = (SQChannelLabel *)self.columnLabelArr[index];
        CGFloat indicatorW = label.width;
        CGFloat indicatorH = 3;
        CGFloat indicatorX = label.x;
        CGFloat indicatorY = self.scrollView.height - indicatorH;
        self.indicatorLine.frame = CGRectMake(indicatorX, indicatorY, indicatorW, indicatorH);
        self.indicatorLine.layer.cornerRadius = indicatorH * 0.5;
        self.indicatorLine.layer.masksToBounds = YES;
        if (self.indicatorLineGetFrame) {
            self.indicatorLineGetFrame(self.indicatorLine);
        }
    }
}

#pragma mark - setter method
- (void)setColumns:(NSArray *)columns{
    _columns = columns;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 由于自己使用了一个数组来记录所有的channelLabel,所以上面的代码并不会释放控件,还需把数组中强指向的channelLabel移除;channelLabel才能真正释放
    [self.columnLabelArr removeAllObjects];
    [self.columnCenterArr removeAllObjects];
    [self.columnWidthArr removeAllObjects];
    
    // 创建scrollView的子控件
    [self createScrollViewSubviews:columns];
    
    // 创建底部的指示线
    if (columns.count > 0 && ![self.scrollView.subviews containsObject:self.indicatorLine]) {
        [self setupIndicatorLine];
    }
    
}

- (void)setupIndicatorLine{
    [self setNeedsLayout];
    
    // addsubview
    [self.scrollView addSubview:self.indicatorLine];
    // setFrame

}

- (void)createScrollViewSubviews:(NSArray *)columns{
    if (columns.count == 0) return;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat labelX = _boundaryMargin;
    for (int i = 0; i < columns.count; ++i) {
        SQChannelLabel *label = [SQChannelLabel channelLabelWithText:columns[i]];
        [self.scrollView addSubview:label];
        [self.columnLabelArr addObject:label];
        
//        label.backgroundColor = label.superview.backgroundColor;
        label.frame = CGRectMake(labelX, 0, label.width, self.columnHeight);
        labelX += label.width + _margin;
        label.normalColor = _labelNormalColor;
        label.highlightedColor = _labelHighlightedColor;
        label.normalFontSize = _labelNormalFontSize;
        label.highlightedFontSize = _labelHighlightedFontSize;
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelLabelTapped:)];
        [label addGestureRecognizer:tapped];
        
        NSNumber *num = [NSNumber numberWithFloat:label.center.x];
        [self.columnCenterArr addObject:num];
        NSNumber *num2 = [NSNumber numberWithFloat:label.width];
        [self.columnWidthArr addObject:num2];
        
        if (i == 0) {
            label.scale = 1.0;
        }
    }
    labelX = labelX - _margin + _boundaryMargin;
    self.scrollView.contentSize = CGSizeMake(labelX, 0);

    [self layoutIfNeeded];
    if (self.scrollView.contentSize.width < self.bounds.size.width) {
        if (_isDivideEquallyWhenContentSizeWidthLessScreenWidth) {
            [self.columnCenterArr removeAllObjects];
            [self.columnWidthArr removeAllObjects];
            labelX = _boundaryMargin;
            CGFloat divideEquallyWidth = (self.bounds.size.width - (2 * _boundaryMargin) - (self.columnLabelArr.count - 1) * _margin) / self.columnLabelArr.count;
            for (int i = 0; i < self.columnLabelArr.count; ++i) {
                SQChannelLabel *lb = self.columnLabelArr[i];
                lb.frame = CGRectMake(labelX, 0, divideEquallyWidth, self.columnHeight);
                labelX += lb.width + _margin;
                
                NSNumber *num = [NSNumber numberWithFloat:lb.center.x];
                [self.columnCenterArr addObject:num];
                NSNumber *num2 = [NSNumber numberWithFloat:lb.width];
                [self.columnWidthArr addObject:num2];
            }
            self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
            
            [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.equalTo(self);
            }];
        }else{
            [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                if (_isMiddle) {
                    make.centerX.equalTo(self);
                }else{
                    make.left.equalTo(self);
                }
                make.width.mas_equalTo(self.scrollView.contentSize.width);
            }];
        }
    }else{
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
    }
}

#pragma mark - load lazy
- (NSMutableArray *)columnLabelArr{
    if (_columnLabelArr == nil) {
        _columnLabelArr = [NSMutableArray array];
    }
    return _columnLabelArr;
}

- (NSMutableArray *)columnWidthArr{
    if (_columnWidthArr == nil) {
        _columnWidthArr = [NSMutableArray array];
    }
    return _columnWidthArr;
}

- (NSMutableArray *)columnCenterArr{
    if (_columnCenterArr == nil) {
        _columnCenterArr = [NSMutableArray array];
    }
    return _columnCenterArr;
}

- (UIView *)indicatorLine{
    if (_indicatorLine == nil) {
        _indicatorLine = [[UIView alloc] init];
        _indicatorLine.backgroundColor = HEX_COLOR(0x73C4F6);
    }
    return _indicatorLine;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _scrollView;
}

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _columnHeight = 36;// 默认高度
        _margin = 20;
        _boundaryMargin = 20;
        _labelNormalColor = HEX_COLOR(0x666666);
        _labelHighlightedColor = HEX_COLOR(0x73C4F6);
        _labelNormalFontSize = 16;
        _labelHighlightedFontSize = 17.5;
        _isDivideEquallyWhenContentSizeWidthLessScreenWidth = NO;
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    // addsubview
    [self addSubview:self.scrollView];
    
    // setlayout
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 
}

#pragma mark - target action
- (void)channelLabelTapped:(UITapGestureRecognizer *)recognizer{
    SQChannelLabel *label = (SQChannelLabel *)recognizer.view;
    NSUInteger index = [self.scrollView.subviews indexOfObject:label];
    if (self.labelTapped) {
        self.labelTapped(index);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    // 如果点到了自己,并且不是点到self.scrollView内;那么自己不响应这个事件
    if (view == self) {
        if (!CGRectContainsPoint(self.scrollView.frame, point)) {
            return nil;
        }
    }
    return view;
}

@end
