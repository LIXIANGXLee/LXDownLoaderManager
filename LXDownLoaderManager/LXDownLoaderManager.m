//
//  LXDownLoaderManager.m
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import "LXDownLoaderManager.h"
#import "LXDownLoader.h"
#import "NSString+MD5.h"

@interface LXDownLoaderManager()<NSCopying, NSMutableCopying>

@property (nonatomic, strong) NSMutableDictionary *downLoads;

@property (nonatomic, assign) dispatch_semaphore_t semaphore;

@end

@implementation LXDownLoaderManager
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
   
- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}
  
- (NSMutableDictionary *)downLoads {
    if (!_downLoads) {
        _downLoads = [NSMutableDictionary dictionary];
    }
    return _downLoads;
}

-(void)setMaxConcurrentCount:(int)count {
    self.semaphore = dispatch_semaphore_create(count);
}


- (void)downLoader:(NSURL *)url downLoadInfo:(LXDownLoadInfoBlock)downLoadInfo stateChange:(LXStateChangeBlock)stateChange progress:(LXProgressBlock)progressBlock success:(LXSuccessBlock)successBlock failed:(LXFailedBlock)failedBlock{
    
    __weak typeof(self) weakSelf = self ;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(self) strongSelf = weakSelf;

        dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
        NSString *urlMD5 = [url.absoluteString md5];
        //查找相应的下载器
        LXDownLoader *downLoader = self.downLoads[urlMD5];
        
        if (downLoader == nil) {
            downLoader = [[LXDownLoader alloc] init];
            downLoader.url = url;
            self.downLoads[urlMD5] = downLoader;
        }
        
        //执行下载任务
        [downLoader downLoader:url downLoadInfo:downLoadInfo stateChange:stateChange progress:progressBlock success:^(NSString * _Nonnull filePath) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.downLoads removeObjectForKey:urlMD5];
            dispatch_semaphore_signal(strongSelf.semaphore);
            if (successBlock) {
                 successBlock(filePath);
            }
        } failed:failedBlock];
        
    });
}

- (void)pauseWithURL:(NSURL *)url {
    NSString *urlMD5 = [url.absoluteString md5];
    LXDownLoader *downLoader = self.downLoads[urlMD5];
    [downLoader pause];
}

- (void)resumeWithURL:(NSURL *)url {
    NSString *urlMD5 = [url.absoluteString md5];
    LXDownLoader *downLoader = self.downLoads[urlMD5];
    [downLoader resume];
}

- (void)cancelWithURL:(NSURL *)url {
    NSString *urlMD5 = [url.absoluteString md5];
    LXDownLoader *downLoader = self.downLoads[urlMD5];
    [downLoader cancel];
}

- (void)pauseAll {
    [self.downLoads.allValues makeObjectsPerformSelector:@selector(pause)];
}

- (void)resumeAll {
    [self.downLoads.allValues makeObjectsPerformSelector:@selector(resume)];
}


@end
