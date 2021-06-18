//
//  LXFileManager.m
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import "LXLoaderFile.h"

@implementation LXLoaderFile

+ (NSString *)documentPath:(NSURL *)url {
    
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:identifier];
    if (![self fileExists:filePath]) {
        BOOL isDir = NO;
        BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
        if (!(isDir && existed)) {
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return [filePath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (NSString *)tmpPath:(NSURL *)url {
    
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:identifier];
    if (![self fileExists:filePath]) {
        BOOL isDir = NO;
        BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
        if (!(isDir && existed)) {
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return [filePath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (BOOL)fileExists:(NSString *)filePath {
    if (!filePath || filePath.length == 0) {
        return NO;
    }
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (long long)fileSize:(NSString *)filePath {
    
    if (![self fileExists:filePath]) {
        return 0;
    }
    
    NSDictionary *fileInfo = [[NSFileManager defaultManager]
                              attributesOfItemAtPath:filePath error:nil];
    return [fileInfo[NSFileSize] longLongValue];
}


+ (void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath {
    
    if (![self fileSize:fromPath]) {
        return;
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:fromPath
                                            toPath:toPath error:nil];
}

+ (void)removeFile:(NSString *)filePath {
   
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


@end
