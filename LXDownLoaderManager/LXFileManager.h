//
//  LXFileManager.h
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXFileManager : NSObject

/**
根据url获取沙盒路径（fileName）

@param url 文件路径
*/
+(NSString *)cachePath:(NSURL *)url;

/**
根据url获取临时路径（fileName）

@param url 文件路径
*/
+(NSString *)tmpPath:(NSURL *)url;

/**
 文件是否存在
 
 @param filePath 文件路径
 @return 是否存在
 */
+ (BOOL)fileExists:(NSString *)filePath;


/**
 文件大小
 
 @param filePath 文件路径
 @return 文件大小
 */
+ (long long)fileSize:(NSString *)filePath;

/**
 移动一个文件,到另外一个文件路径中
 
 @param fromPath 从哪个文件
 @param toPath 目标文件位置
 */
+ (void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 删除某个文件
 
 @param filePath 文件路径
 */
+ (void)removeFile:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
