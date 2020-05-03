//
//  LXDownLoader.m
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import "LXDownLoader.h"
#import "LXFileManager.h"

@interface LXDownLoader ()<NSURLSessionDataDelegate>
{
    /// 记录文件临时下载大小
    long long _tmpSize;
    /// 记录文件总大小
    long long _totalSize;
}
/** 下载会话 */
@property (nonatomic, strong) NSURLSession *session;
/** 下载完成路径 */
@property (nonatomic, copy) NSString *downLoadedPath;
/** 下载临时路径 */
@property (nonatomic, copy) NSString *downLoadingPath;
/** 文件输出流 */
@property (nonatomic, strong) NSOutputStream *outputStream;
/** 当前下载任务 */
@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

@end

@implementation LXDownLoader

#pragma mark - 提供给外界的接口
- (void)downLoader:(NSURL *)url downLoadInfo:(LXDownLoadInfoBlock)downLoadInfo stateChange:(LXStateChangeBlock)stateChange progress:(LXProgressBlock)progressBlock success:(LXSuccessBlock)successBlock failed:(LXFailedBlock)failedBlock {
    
    // 回调 block赋值
    self.downLoadInfo = downLoadInfo;
    self.progressChange = progressBlock;
    self.stateChange = stateChange;
    self.successBlock = successBlock;
    self.faildBlock = failedBlock;
    
    // 开始下载
    [self downLoader:url];
}

/**
 根据URL地址下载资源, 如果任务已经存在, 则执行继续动作
 @param url 资源路径
 */
- (void)downLoader:(NSURL *)url {

    // 判断当前任务是否存在, 存在的话判断Url地址是否相等相同 再判断是否暂停状态
    if ([url isEqual:self.dataTask.originalRequest.URL]) {
        // 判断当前的状态, 如果是暂停状态
        if (self.state == LXDownLoadStatePause) {
            [self resume];
            return;
        }
    }
    
   // 下载前 先取消上次下载（处理异常判断）
    [self cancel];
    NSString *fileName = url.lastPathComponent;
    self.downLoadedPath = [kCachePath stringByAppendingPathComponent:fileName];
    self.downLoadingPath = [kTmpPath stringByAppendingPathComponent:fileName];
    
    if ([LXFileManager fileExists:self.downLoadedPath]) {
        self.state = LXDownLoadStateSuccess;
        return;
    }
    
    //  判断临时文件是否存在: 不存在从0字节开始请求资源
    if (![LXFileManager fileExists:self.downLoadingPath]) {
        // 从0字节开始请求资源
        [self downLoadWithURL:url offset:0];
        return;
    }
    
    //临时文件存在说明下载过 则继续下载
    _tmpSize = [LXFileManager fileSize:self.downLoadingPath];
    [self downLoadWithURL:url offset:_tmpSize];
}

/**
 暂停任务
 */
- (void)pause {
    if (self.state == LXDownLoadStateDownLoading) {
        self.state = LXDownLoadStatePause;
        [self.dataTask suspend];
    }
}

/**
 继续任务
 */
- (void)resume {
    if (self.dataTask && self.state == LXDownLoadStatePause) {
        [self.dataTask resume];
        self.state = LXDownLoadStateDownLoading;
    }
}

/**
 取消当前任务
 */
- (void)cancel {
    self.state = LXDownLoadStatePause;
    [self.session invalidateAndCancel];
    self.session = nil;
}

/**
 取消任务, 并清理资源
 */
- (void)cancelAndClean {
    [self cancel];
    [LXFileManager removeFile:self.downLoadingPath];
}


#pragma mark - 系统 协议方法
/**
 第一次接收响应时回调
 @param session 会话
 @param dataTask 任务
 @param response 响应头信息
 @param completionHandler 系统回调代码块, 通过它可以控制是否继续接收数据
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    // 取资源总大小
    _totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    // 回调函数响应 总大小 & 本地存储的文件路径
    if (self.downLoadInfo) {
        self.downLoadInfo(_totalSize);
    }
    
    // 本地临时文件大小和数据总大小比较 相等 说明下载成功
    if (_tmpSize == _totalSize) {
        // 移动到下载完成文件夹
        [LXFileManager moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        // 已经下载成功 所以取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        // 修改下载状态
        self.state = LXDownLoadStateSuccess;
        return;
    }
    
    
    // 本地临时文件大小和数据总大小比较 临时文件大 说明存在异常 需要重新下载
    if (_tmpSize > _totalSize) {
        [LXFileManager removeFile:self.downLoadingPath];
        completionHandler(NSURLSessionResponseCancel);
        [self downLoader:response.URL];
        return;
    }
    
    self.state = LXDownLoadStateDownLoading;
    // 继续接受数据
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downLoadingPath append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    // 这就是当前已经下载的大小
    _tmpSize += data.length;
    self.progress =  1.0 * _tmpSize / _totalSize;
    
    // 往输出流中写入数据
    [self.outputStream write:data.bytes maxLength:data.length];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error == nil) {
        [LXFileManager moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        self.state = LXDownLoadStateSuccess;
        
    }else {
        // 取消,  断网
        if (error.code == -999) {
            self.state = LXDownLoadStatePause;
        }else {
            self.state = LXDownLoadStateFailed;
            
            if (self.faildBlock) {
                self.faildBlock(error);
            }
        }
    }
    [self.outputStream close];
    
}


#pragma mark - 私有方法
/**
 根据开始字节, 请求资源
 
 @param url url
 @param offset 开始字节
 */
- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    // 通过控制range, 控制请求资源字节区间
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    // session 分配的task, 默认情况, 挂起状态
    self.dataTask = [self.session dataTaskWithRequest:request];
    [self resume];
    
}

#pragma mark - 懒加载
/**
 懒加载会话
 @return 会话
 */
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


#pragma mark - 事件/数据传递
- (void)setState:(LXDownLoadState)state {
    // 数据过滤（状态不变 则不需要处理）
    if(_state == state) {
        return;
    }
    _state = state;
    // 代理, block, 通知
    if (self.stateChange) {
        self.stateChange(_state);
    }
    
    //成功回调
    if (_state == LXDownLoadStateSuccess && self.successBlock) {
        self.successBlock(self.downLoadedPath);
    }
}

- (void)setProgress:(float)progress {
    _progress = progress;
    if (self.progressChange) {
        self.progressChange(_progress);
    }
}

@end
