//
//  LXDownLoaderManager.h
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LXDownLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXDownLoaderManager : NSObject
/**
 单例模式
 */
+ (instancetype)shareInstance;
/**
根据URL地址下载资源 (回调为子线程)
@param url 资源路径
@param downLoadInfo 资源资源大小回调
@param stateChange 下载状态回调
@param progressBlock 下载进度回调
@param successBlock 下载成功回调
@param failedBlock 下载失败回调
*/
- (void)downLoader:(NSURL *)url downLoadInfo:(LXDownLoadInfoBlock)downLoadInfo stateChange:(LXStateChangeBlock)stateChange progress:(LXProgressBlock)progressBlock  success:(LXSuccessBlock)successBlock failed:(LXFailedBlock)failedBlock;

/**
根据URL地址暂停下载资源
@param url 资源路径
*/
- (void)pauseWithURL:(NSURL *)url;

/**
根据URL地址继续下载资源
@param url 资源路径
*/
- (void)resumeWithURL:(NSURL *)url;

/**
根据URL地址取消下载资源
@param url 资源路径
*/
- (void)cancelWithURL:(NSURL *)url;

/**
  暂停全部任务
*/
- (void)pauseAll;
/**
  继续下载全部任务
*/
- (void)resumeAll;

/**
 设置最大并发数
 */
-(void)setMaxConcurrentCount:(int)count;

@end

NS_ASSUME_NONNULL_END
