//
//  LXDownLoader.h
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 状态判断枚举类型
 */
typedef NS_ENUM(NSUInteger, LXDownLoadState) {
    
    LXDownLoadStatePause, // 暂停
    LXDownLoadStateDownLoading, // 下载
    LXDownLoadStateSuccess, // 下载成功
    LXDownLoadStateFailed //下载失败
};

/**
 根据URL地址下载事件回调
 */
typedef void(^LXDownLoadInfoBlock)(long long totalSize);
typedef void(^LXProgressBlock)(float progress);
typedef void(^LXSuccessBlock)(NSString *filePath);
typedef void(^LXFailedBlock)(NSError *error);
typedef void(^LXStateChangeBlock)(LXDownLoadState state);

@interface LXDownLoader : NSObject

/**
 根据URL地址下载资源
 @param url 资源路径
 @param downLoadInfo 资源资源大小回调
 @param stateChange 下载状态回调
 @param progressBlock 下载进度回调
 @param successBlock 下载成功回调
 @param failedBlock 下载失败回调
 */
- (void)downLoader:(NSURL *)url downLoadInfo:(LXDownLoadInfoBlock)downLoadInfo stateChange:(LXStateChangeBlock)stateChange progress:(LXProgressBlock)progressBlock  success:(LXSuccessBlock)successBlock failed:(LXFailedBlock)failedBlock;

/**
 根据URL地址下载资源（下载或者继续下载）需要自己设置回调
 @param url 资源路径
 */
- (void)downLoader:(NSURL *)url;
- (void)resume;

/**
 暂停任务
 */
- (void)pause;

/**
 取消任务
 */
- (void)cancel;

/**
 取消任务, 并清理资源
 */
- (void)cancelAndClean;

/**
 保存原url
 */
@property (nonatomic, strong)NSURL * url;
    
/**
 事件&数据
 */
@property (nonatomic, assign, readonly)LXDownLoadState state;
@property (nonatomic, assign, readonly)float progress;

/**
 事件监听回调
 */
@property (nonatomic, copy)LXDownLoadInfoBlock downLoadInfo;
@property (nonatomic, copy)LXStateChangeBlock stateChange;
@property (nonatomic, copy)LXProgressBlock progressChange;
@property (nonatomic, copy)LXSuccessBlock successBlock;
@property (nonatomic, copy)LXFailedBlock faildBlock;

@end

NS_ASSUME_NONNULL_END
