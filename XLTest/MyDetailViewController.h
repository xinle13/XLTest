//
//  MyDetailViewController.h
//  XLTest
//
//  Created by admin on 2018/3/12.
//  Copyright © 2018年 xinle. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void(^ReturnBlock)(NSString * str);

@interface MyDetailViewController : UIViewController

@property (nonatomic, strong)ReturnBlock returnBlock;

@end
