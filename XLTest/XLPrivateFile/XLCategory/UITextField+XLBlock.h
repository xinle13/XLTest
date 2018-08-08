//
//  UITextField+XLBlock.h
//  ZJNews
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 FXEYE. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TextFieldStrBlock)(NSString *str);
@interface UITextField (XLBlock)

-(void)addAactionBlock:(TextFieldStrBlock)block forControlEvents:(UIControlEvents)event;

@end
