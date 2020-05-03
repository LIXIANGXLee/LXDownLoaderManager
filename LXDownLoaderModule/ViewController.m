//
//  ViewController.m
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import "ViewController.h"

#import <LXDownLoaderManager/LXDownLoaderManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    LXDownLoaderManager * manager = [LXDownLoaderManager shareInstance];
    [manager setMaxConcurrentCount:2];
    
    [manager downLoader:[NSURL URLWithString:@"https://img.coffeesss.com/image/6836e0f6e55bd80314c1ab70e5d9f132.mp4"] downLoadInfo:^(long long totalSize) {
        NSLog(@"-1--------%lld",totalSize);

    } stateChange:^(LXDownLoadState state) {
        NSLog(@"-1------------------------------%lu",(unsigned long) state);

    } progress:^(float progress) {
        NSLog(@"-1--------%f",progress);

    } success:^(NSString * _Nonnull filePath) {
        NSLog(@"-1--------%@",filePath);

    } failed:^(NSError * _Nonnull error) {
        NSLog(@"-1--------%@",error);
    }];

}


@end
