//
//  UIButton+XLBlock.h
//  XLTest
//
//  Created by admin on 2018/4/16.
//  Copyright © 2018年 xinle. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActionBlock)(UIButton *btn);
typedef UIButton *(^XLBtnBlock)(CGRect frame);
typedef UIButton *(^XLBtnTitleBlock)(NSString *title);
@interface UIButton (XLBlock)

@property (nonatomic, copy)XLBtnBlock xl_frame;
@property (nonatomic, copy)XLBtnTitleBlock xl_title;
-(void)addActionBlock:(ActionBlock)actionBlock forControlEvents:(UIControlEvents)event;

@end
