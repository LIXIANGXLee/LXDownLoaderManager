//
//  LXFileManager.m
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import "LXLoaderFile.h"

#define BUNDLEIDENTIFIER [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] stringByAppendingPathComponent:@"IosFile"]

#define DIRECTORIESPATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
 
@implementation LXLoaderFile

+ (NSString *)documentPath:(NSURL *)url {
   
    NSString *filePath = [DIRECTORIESPATH stringByAppendingPathComponent:BUNDLEIDENTIFIER];
    if (![self fileExists:filePath]) {
        [self createDirectory:filePath];
    }
    return [filePath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (NSString *)tmpPath:(NSURL *)url {
    
    NSString *filePath = [[DIRECTORIESPATH stringByAppendingPathComponent:BUNDLEIDENTIFIER]
                          stringByAppendingPathComponent:@"tempIosFile"];
    if (![self fileExists:filePath]) {
        [self createDirectory:filePath];
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
   
    if ([self fileExists:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+ (void)createDirectory:(NSString *)filePath {
    BOOL isDir = NO;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
    if (!(isDir && existed)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)clearTmp {
    NSString *filePath = [[DIRECTORIESPATH stringByAppendingPathComponent:BUNDLEIDENTIFIER]
                          stringByAppendingPathComponent:@"tempIosFile"];
    if ([self fileExists:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+ (void)clearDocument {
    NSString *filePath = [DIRECTORIESPATH stringByAppendingPathComponent:BUNDLEIDENTIFIER];
    if ([self fileExists:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
