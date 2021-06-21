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
{
    LXDownLoaderManager * manager ;
    UIProgressView *progressView1;
    UIProgressView *progressView2;
    UIProgressView *progressView3;
    UIProgressView *progressView4;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    progressView1 = [[UIProgressView alloc] init];
    progressView1.progress = 0;
    progressView1.frame = CGRectMake(20, 60, 200, 30);
    [self.view addSubview:progressView1];
   
    progressView2 = [[UIProgressView alloc] init];
    progressView2.progress = 0;
    progressView2.frame = CGRectMake(20, 100, 200, 30);
    [self.view addSubview:progressView2];
 
    progressView3 = [[UIProgressView alloc] init];
    progressView3.progress = 0;
    progressView3.frame = CGRectMake(20, 140, 200, 30);
    [self.view addSubview:progressView3];
 
    progressView4 = [[UIProgressView alloc] init];
    progressView4.progress = 0;
    progressView4.frame = CGRectMake(20, 180, 200, 30);
    [self.view addSubview:progressView4];
 
    
    UIButton *startbutton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [startbutton1 setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:startbutton1];
    startbutton1.frame = CGRectMake(CGRectGetMaxX(progressView1.frame), progressView1.frame.origin.y, 60, 30);
    [startbutton1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *startbutton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [startbutton2 setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:startbutton2];
    startbutton2.frame = CGRectMake(CGRectGetMaxX(progressView2.frame), progressView2.frame.origin.y, 60, 30);
    [startbutton2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
 
    UIButton *startbutton3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [startbutton3 setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:startbutton3];
    startbutton3.frame = CGRectMake(CGRectGetMaxX(progressView3.frame), progressView3.frame.origin.y, 60, 30);
    [startbutton3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
 
    UIButton *startbutton4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [startbutton4 setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:startbutton4];
    startbutton4.frame = CGRectMake(CGRectGetMaxX(progressView4.frame), progressView4.frame.origin.y, 60, 30);
    [startbutton4 addTarget:self action:@selector(button4Click) forControlEvents:UIControlEventTouchUpInside];
     
    UIButton *pausebutton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [pausebutton1 setTitle:@"暂停" forState:UIControlStateNormal];
    [self.view addSubview:pausebutton1];
    pausebutton1.frame = CGRectMake(CGRectGetMaxX(startbutton1.frame) + 20, startbutton1.frame.origin.y, 60, 30);
    [pausebutton1 addTarget:self action:@selector(pause1Click) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pausebutton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [pausebutton2 setTitle:@"暂停" forState:UIControlStateNormal];
    [self.view addSubview:pausebutton2];
    pausebutton2.frame = CGRectMake(CGRectGetMaxX(startbutton2.frame) + 20, startbutton2.frame.origin.y, 60, 30);
    [pausebutton2 addTarget:self action:@selector(pause2Click) forControlEvents:UIControlEventTouchUpInside];
 
    UIButton *pausebutton3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [pausebutton3 setTitle:@"暂停" forState:UIControlStateNormal];
    [self.view addSubview:pausebutton3];
    pausebutton3.frame = CGRectMake(CGRectGetMaxX(startbutton3.frame) + 20, startbutton3.frame.origin.y, 60, 30);
    [pausebutton3 addTarget:self action:@selector(pause3Click) forControlEvents:UIControlEventTouchUpInside];
 
    UIButton *pausebutton4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [pausebutton4 setTitle:@"暂停" forState:UIControlStateNormal];
    [self.view addSubview:pausebutton4];
    pausebutton4.frame = CGRectMake(CGRectGetMaxX(startbutton4.frame) + 20, startbutton4.frame.origin.y, 60, 30);
    [pausebutton4 addTarget:self action:@selector(pause4Click) forControlEvents:UIControlEventTouchUpInside];
     

   UIButton *clearbutton = [UIButton buttonWithType:UIButtonTypeSystem];
   [clearbutton setTitle:@"清空" forState:UIControlStateNormal];
   [self.view addSubview:clearbutton];
   clearbutton.frame = CGRectMake(30, 200, 60, 30);
   [clearbutton addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
        
       
    
    manager = [LXDownLoaderManager shareInstance];
    [manager setMaxConcurrentCount:20];

}

- (void)button1Click{
    [manager downLoader:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/8B952A30-CD2F-4E77-ABED-EC1DDF4AA67E.2.videofx"] downLoadInfo:^(long long totalSize) {

    } stateChange:^(LXDownLoadState state) {
        NSLog(@"========-=-=-=-=-==-=-=%lu",(unsigned long)state);

    } progress:^(float progress) {
        
//        NSLog(@"---------%f",progress);

        self->progressView1.progress = progress;
    } success:^(NSString * _Nonnull filePath) {
        NSLog(@"---------%@",filePath);

    } failed:^(NSError * _Nonnull error) {
        NSLog(@"---------%@", error);
    }];

}


- (void)button2Click{
    [manager downLoader:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/2A86D624-BF4C-4389-83A1-7F293FA7660B.1.videofx"] downLoadInfo:^(long long totalSize) {

    } stateChange:^(LXDownLoadState state) {

        
    } progress:^(float progress) {
        self->progressView2.progress = progress;
    } success:^(NSString * _Nonnull filePath) {
        NSLog(@"---------%@",filePath);

    } failed:^(NSError * _Nonnull error) {
        NSLog(@"---------%@", error);
    }];
}


- (void)button3Click{
    [manager downLoader:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/B8D91810-03C7-4100-BEC6-3B832C0A3D01.2.videofx"] downLoadInfo:^(long long totalSize) {

    } stateChange:^(LXDownLoadState state) {

    } progress:^(float progress) {
        self->progressView3.progress = progress;
    } success:^(NSString * _Nonnull filePath) {
        NSLog(@"---------%@",filePath);

    } failed:^(NSError * _Nonnull error) {
        NSLog(@"---------%@", error);
    }];
}

- (void)button4Click{
    [manager downLoader:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/A13C3698-7257-49EE-948E-8D4F805DA1FC.1.videofx"] downLoadInfo:^(long long totalSize) {

    } stateChange:^(LXDownLoadState state) {

    } progress:^(float progress) {
        self->progressView4.progress = progress;
    } success:^(NSString * _Nonnull filePath) {
        NSLog(@"---------%@",filePath);

    } failed:^(NSError * _Nonnull error) {
        NSLog(@"---------%@", error);
    }];
}
- (void)pause1Click{
    [manager pauseWithURL:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/8B952A30-CD2F-4E77-ABED-EC1DDF4AA67E.2.videofx"] ];
}
- (void)pause2Click{
    [manager pauseWithURL:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/2A86D624-BF4C-4389-83A1-7F293FA7660B.1.videofx"] ];
}
- (void)pause3Click{
    [manager pauseWithURL:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/B8D91810-03C7-4100-BEC6-3B832C0A3D01.2.videofx"] ];
}
- (void)pause4Click{
    [manager pauseWithURL:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/A13C3698-7257-49EE-948E-8D4F805DA1FC.1.videofx"] ];
}

- (void)clearClick {
    [manager clearAllDocumentAndLoader];
    progressView1.progress = 0;
    progressView2.progress = 0;
    progressView3.progress = 0;
    progressView4.progress = 0;

}

@end
