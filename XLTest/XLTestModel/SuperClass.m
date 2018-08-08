//
//  SuperClass.m
//  XLTest
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 xinle. All rights reserved.
//

#import "SuperClass.h"

@implementation SuperClass

+ (void)load{
    
    NSLog(@"SuperClass的load方法");
}

+ (void)initialize
{
    NSLog(@"SuperClass的initialize方法");
}

-(void)userMethod{
    NSLog(@"SuperClass的userMethod方法");
}

@end
