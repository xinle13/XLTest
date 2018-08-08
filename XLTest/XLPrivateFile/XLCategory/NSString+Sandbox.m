//
//  NSString+Sandbox.m
//  06-getSanboxDirectory
//
//  Created by Franky on 2017/8/12.
//  Copyright © 2017年 MasterKing. All rights reserved.
//

#import "NSString+Sandbox.h"

@implementation NSString (Sandbox)

- (instancetype)appendCacheDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:self.lastPathComponent];
}

- (instancetype)appendTempDirectory{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self.lastPathComponent];
}

- (instancetype)appendDocumentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:self.lastPathComponent];
}

@end
