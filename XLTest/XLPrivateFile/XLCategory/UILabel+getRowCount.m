//
//  UILabel+getRowCount.m
//  ZJNews
//
//  Created by Franky on 2017/7/7.
//  Copyright © 2017年 Bella. All rights reserved.
//

#import "UILabel+getRowCount.h"

@implementation UILabel (getRowCount)

- (NSInteger)getLines{
    CGFloat rowCount = self.height / self.font.lineHeight;
    return (NSInteger)rowCount;
}
@end
