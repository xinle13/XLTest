//
//  SuperClass+UserMethod.m
//  XLTest
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 xinle. All rights reserved.
//

#import "SuperClass+UserMethod.h"

@implementation SuperClass (UserMethod)

+ (void)load{
    
    NSLog(@"SuperClass (UserMethod)的load方法");
}

+ (void)initialize
{
    NSLog(@"SuperClass (UserMethod)的initialize方法");
}

@end
