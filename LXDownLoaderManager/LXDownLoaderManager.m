//
//  LXDownLoaderManager.m
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import "LXDownLoaderManager.h"
#import "LXDownLoader.h"
#import "NSString+LXTool.h"
#import "LXLoaderFile.h"

@interface LXDownLoaderManager()

@property (nonatomic, strong)NSMutableDictionary *downLoads;

@end

@implementation LXDownLoaderManager
{
    dispatch_semaphore_t _semaphore;
}
static LXDownLoaderManager *_shareInstance;
+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setMaxConcurrentCount:5];
    }
    return self;
}
    
- (NSMutableDictionary *)downLoads {
    if (!_downLoads) {
        _downLoads = [NSMutableDictionary dictionary];
    }
    return _downLoads;
}

-(void)setMaxConcurrentCount:(int)count {
    _semaphore = dispatch_semaphore_create(count);
}

- (void)downLoader:(NSURL *)url
      downLoadInfo:(LXDownLoadInfoBlock)downLoadInfo
       stateChange:(LXStateChangeBlock)stateChange
          progress:(LXProgressBlock)progressBlock
           success:(LXSuccessBlock)successBlock
            failed:(LXFailedBlock)failedBlock{
    
    // url为空或者不是有效的http和https链接 直接返回 不做任何处理
    if (LX_OBJC_ISEMPTY(url.absoluteString) || !url.absoluteString.isValidURL) {
        return;
    }
    
    __weak typeof(self) weakSelf = self ;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(self) strongSelf = weakSelf;
        NSString *urlMD5 = [url.absoluteString lx_md5];
        LXDownLoader *downLoader = strongSelf.downLoads[urlMD5];
        if (!downLoader) {
            downLoader = [[LXDownLoader alloc] init];
            strongSelf.downLoads[urlMD5] = downLoader;
            dispatch_semaphore_wait(strongSelf->_semaphore,
                                    DISPATCH_TIME_FOREVER);
            //执行下载任务
            [downLoader downLoader:url
                      downLoadInfo:downLoadInfo
                       stateChange:stateChange
                          progress:progressBlock
                           success:^(NSString * _Nonnull filePath) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf.downLoads removeObjectForKey:urlMD5];
                dispatch_semaphore_signal(strongSelf->_semaphore);
                if (successBlock) { successBlock(filePath); }
                
            } failed:failedBlock];
        }else{
            [downLoader resumeTask];
        }
        
    });
}

- (void)pauseWithURL:(NSURL *)url {
    [self downLoaderWithURL:url
             handleComplete:^(LXDownLoader * _Nullable downLoader) {
        if (downLoader) { [downLoader pauseAndCancelTask]; }
    }];
}

- (void)resumeWithURL:(NSURL *)url {
    [self downLoaderWithURL:url
             handleComplete:^(LXDownLoader * _Nullable downLoader) {
        if (downLoader) { [downLoader resumeTask]; }
    }];
}

- (void)cancelWithURL:(NSURL *)url {
    [self downLoaderWithURL:url
             handleComplete:^(LXDownLoader * _Nullable downLoader) {
        if (downLoader) { [downLoader pauseAndCancelTask]; }
    }];
}

- (void)downLoaderWithURL:(NSURL *)url
           handleComplete:(void(^)(LXDownLoader * _Nullable downLoader))handleComplete {
    // url为空或者不是有效的http和https链接 直接返回 不做任何处理
    if (LX_OBJC_ISEMPTY(url.absoluteString) || !url.absoluteString.isValidURL) {
        if (handleComplete) { handleComplete(nil); }
    }
    NSString *urlMD5 = [url.absoluteString lx_md5];
    LXDownLoader *downLoader = self.downLoads[urlMD5];
    if (handleComplete) {
        handleComplete(downLoader);
    }
}

- (void)pauseAll {
    [self.downLoads enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                                        LXDownLoader *downLoader,
                                                        BOOL * _Nonnull stop) {
        [downLoader pauseAndCancelTask];
    }];
}

- (void)resumeAll {
    [self.downLoads enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                                        LXDownLoader *downLoader,
                                                        BOOL * _Nonnull stop) {
        [downLoader resumeTask];
    }];
}

- (BOOL)isCheckUrlInLocal:(NSURL *)url {
    NSString *downLoadedPath = [self getLocalDownloadPath:url];
    if (!downLoadedPath) {
        return  NO;
    }
    return [LXLoaderFile fileExists:downLoadedPath];
}

- (NSString *)getLocalDownloadPath:(NSURL *)url {
    if (!url) { return  nil; }
    return [LXLoaderFile documentPath:url];
}

- (long long)getDownloadedLengthWithUrl:(NSURL *)url {
    if (!url) { return  0; }
    NSString *tPath = [LXLoaderFile tmpPath:url];
    long long fileSize = [LXLoaderFile fileSize:tPath];
    if (fileSize <= 0) {
        NSString *dPath = [LXLoaderFile documentPath:url];
        fileSize = [LXLoaderFile fileSize:dPath];
    }
    return fileSize;
}

- (void)clearAllDocumentAndLoader {
    [self.downLoads enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                                        LXDownLoader *downLoader,
                                                        BOOL * _Nonnull stop) {
        [downLoader pauseAndCancelTask];
    }];
    
    [self.downLoads removeAllObjects];
    [LXLoaderFile clearDocument];
    
}

@end
