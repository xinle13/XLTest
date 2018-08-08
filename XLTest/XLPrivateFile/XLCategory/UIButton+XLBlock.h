//
//  UIButton+XLBlock.h
//  ZJNews
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 FXEYE. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnActionBlock)(UIButton *btn);
typedef UIButton *(^XLBtnFrameBlock)(CGRect frame);
typedef UIButton *(^XLBtnTitleBlock)(NSString *title);
@interface UIButton (XLBlock)

@property (nonatomic, copy)XLBtnFrameBlock xl_frame;
@property (nonatomic, copy)XLBtnTitleBlock xl_title;
-(void)addActionBlock:(BtnActionBlock)actionBlock forControlEvents:(UIControlEvents)event;

@end
