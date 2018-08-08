//
//  NSObject+Ext.h
//  ZJNews
//
//  Created by Franky on 2017/9/22.
//  Copyright © 2017年 Bella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Ext)
/**
 获取沙盒Library/Caches目录下的模型数组
 
 @param fileName 文件名
 @return 模型数组
 */
- (instancetype)getSandBoxCachesDataWithFileName:(NSString *)fileName;

/**
 将模型数组写入沙盒Library/Caches目录下
 
 @param dataArr 存放模型的数组
 @param fileName 文件名
 */
- (void)saveData:(id)obj fileName:(NSString *)fileName;

/**
 移除沙盒Library/Caches目录下的指定文件
 
 @param fileName 指定文件名
 @param complete 完成的回调
 */
- (void)removeDataWithFileName:(NSString *)fileName complete:(void (^)(BOOL success,NSError *error))complete;

@end
