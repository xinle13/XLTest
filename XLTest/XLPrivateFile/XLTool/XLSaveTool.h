//
//  XLSaveTool.h
//  ZJNews
//
//  Created by admin on 2018/6/29.
//  Copyright © 2018年 FXEYE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLSaveTool : NSObject

/**
 获取沙盒Library/Caches目录下的模型数组
 @param filePath 文件路径
 fileName 文件名
 @return obj
 */
+(instancetype)getCachesDataWithFilePath:(NSString *)filePath FileName:(NSString *)fileName;

/**
 将数据存放到沙盒Library/Caches目录下
 @param obj 实际的数据
 filePath 文件路径
 fileName 文件名
 @return obj
 */
+(void)saveObj:(id)obj ToFilePath:(NSString *)filePath AsFileName:(NSString *)fileName;

/**
 移除沙盒Library/Caches目录下的指定文件
 @param filePath 文件路径
 fileName 文件名
 */
+(void)removeDataWithFilePath:(NSString *)filePath FileName:(NSString *)fileName;

/**
 移除沙盒Library/Caches目录下的指定文件夹
 @param filePath 文件路径
 */
+(void)removeDataWithFilePath:(NSString *)filePath;

@end
