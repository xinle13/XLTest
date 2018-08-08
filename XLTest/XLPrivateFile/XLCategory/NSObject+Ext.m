//
//  NSObject+Ext.m
//  ZJNews
//
//  Created by Franky on 2017/9/22.
//  Copyright © 2017年 Bella. All rights reserved.
//

#import "NSObject+Ext.h"

@implementation NSObject (Ext)
/**
 获取沙盒Library/Caches目录下的模型数组
 
 @param fileName 文件名
 @return 模型数组
 */
- (instancetype)getSandBoxCachesDataWithFileName:(NSString *)fileName{
    //1.读取
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
    //2.拼接文件名
    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

/**
 将模型数组写入沙盒Library/Caches目录下
 
 @param dataArr 存放模型的数组
 @param fileName 文件名
 */
- (void)saveData:(id)obj fileName:(NSString *)fileName{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
        NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
        [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    });
}

/**
 移除沙盒Library/Caches目录下的指定文件

 @param fileName 指定文件名
 @param complete 完成的回调
 */
- (void)removeDataWithFileName:(NSString *)fileName complete:(void (^)(BOOL success,NSError *error))complete{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //1.读取
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
        //2.拼接文件名
        NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
        //3.移除
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(success,error);
            });
        }
    });
}

@end
