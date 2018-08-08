//
//  SubClass1.m
//  XLTest
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 xinle. All rights reserved.
//

#import "SubClass1.h"
#import "SuperClass+UserMethod.h"

@implementation SubClass1

+ (void)load{
    
    NSLog(@"SubClass1的load方法");
}

+ (void)initialize
{
    NSLog(@"SubClass1的initialize方法");
}

-(void)userMethod{
    [super userMethod];
    NSLog(@"SubClass1的userMethod方法");
}

@end
