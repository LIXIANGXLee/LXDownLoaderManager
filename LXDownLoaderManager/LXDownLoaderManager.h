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

/**单例模式*/
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
- (void)downLoader:(NSURL *)url
      downLoadInfo:(LXDownLoadInfoBlock _Nullable)downLoadInfo
       stateChange:(LXStateChangeBlock _Nullable)stateChange
          progress:(LXProgressBlock _Nullable)progressBlock
           success:(LXSuccessBlock _Nullable)successBlock
            failed:(LXFailedBlock _Nullable)failedBlock;

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

/**暂停全部任务*/
- (void)pauseAll;

/**继续下载全部任务*/
- (void)resumeAll;

/**设置最大并发数 建议不要太大*/
-(void)setMaxConcurrentCount:(int)count;

/**检查资源是否已经下载到本地了*/
- (BOOL)isCheckUrlInLocal:(NSURL *)url;

/**获取下载后的本地路径*/
- (NSString *)getLocalDownloadPath:(NSURL *)url;

/**获取已下载文件大小 临时文件大小 如果下载完成的 此方法获取大小为0 */
- (NSInteger)getDownloadedLengthWithUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
