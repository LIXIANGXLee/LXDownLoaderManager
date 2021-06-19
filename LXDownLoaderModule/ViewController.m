//
//  ViewController.m
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import "ViewController.h"

#import <LXDownLoaderManager/LXDownLoaderManager.h>
#import <LXDownLoaderManager/LXDownLoaderManager-umbrella.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    LXDownLoaderManager * manager = [LXDownLoaderManager shareInstance];
    [manager setMaxConcurrentCount:20];
    
   
    NSArray * arr = @[ ];
    
    [arr enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager downLoader:[NSURL URLWithString:obj] downLoadInfo:^(long long totalSize) {
            NSLog(@"-%lu--------%lld",(unsigned long)idx,totalSize);

        } stateChange:^(LXDownLoadState state) {
            NSLog(@"-%lu--------%lu",(unsigned long)idx,(unsigned long) state);

        } progress:^(float progress) {
            NSLog(@"-%lu--------%f",(unsigned long)idx,progress);

        } success:^(NSString * _Nonnull filePath) {
            NSLog(@"-%lu--------%@",(unsigned long)idx,filePath);

        } failed:^(NSError * _Nonnull error) {
            NSLog(@"-%lu--------%@",(unsigned long)idx, error);
        }];
    }];
    

}


@end
