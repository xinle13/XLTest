//
//  NSString+Sandbox.h
//  06-getSanboxDirectory
//
//  Created by Franky on 2017/8/12.
//  Copyright © 2017年 MasterKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Sandbox)

- (instancetype)appendCacheDirectory;

- (instancetype)appendTempDirectory;

- (instancetype)appendDocumentDirectory;

@end
