//
//  XLSaveTool.m
//  ZJNews
//
//  Created by admin on 2018/6/29.
//  Copyright © 2018年 FXEYE. All rights reserved.
//

#import "XLSaveTool.h"

@implementation XLSaveTool


/**
 获取沙盒Library/Caches目录下的模型数组
 @param filePath 文件路径
        fileName 文件名
 @return obj
 */
+(instancetype)getCachesDataWithFilePath:(NSString *)filePath FileName:(NSString *)fileName{
    //1.读取
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
    //2.拼接文件名
    filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.txt",filePath,fileName]];
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

/**
 将数据存放到沙盒Library/Caches目录下
 @param obj 实际的数据
        filePath 文件路径
        fileName 文件名
 @return obj
 */
+(void)saveObj:(id)obj ToFilePath:(NSString *)filePath AsFileName:(NSString *)fileName{
    
    //1.读取
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
    
    // 在沙盒Library/Caches目录下创建 filePath 文件夹
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    
    if (!(isDir && existed)) {
        // 在沙盒Library/Caches目录下创建 filePath 文件夹
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 在 filePath 下写入文件
    NSString *path = [dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
        [NSKeyedArchiver archiveRootObject:data toFile:path];
    });
}

/**
 移除沙盒Library/Caches目录下的指定文件
 @param filePath 文件路径
        fileName 文件名
 */
+(void)removeDataWithFilePath:(NSString *)filePath FileName:(NSString *)fileName{
    //1.读取
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
    //2.拼接文件名
    filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.txt",filePath,fileName]];
    //3.移除
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

/**
 移除沙盒Library/Caches目录下的指定文件夹
 @param filePath 文件路径
 */
+(void)removeDataWithFilePath:(NSString *)filePath{
    //1.读取
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
    //2.拼接文件夹
    filePath = [docDir stringByAppendingPathComponent:filePath];
    //3.移除
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

@end
