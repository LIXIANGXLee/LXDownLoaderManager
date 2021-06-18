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
    
    NSArray * arr = @[@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/BCD1FAAD-D5C5-468F-A4F2-1C2138F485C0.3.videofx",
    @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/3F073D0E-FEF9-45AE-82E6-58DF220F07B8.6.videofx",
    @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/2ABB5A04-D2E0-4794-9338-03AD1663AE2A.2.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/91B91F8D-2C7D-4BAE-A869-CF4003BB2E70.1.videofx",
    @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/35B954E1-8D38-40BC-A567-F6DA1D557950.2.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/F17F414B-B1E2-4FB8-BD29-FEFDA43FCB98.1.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/0C6D17E4-1B59-42EA-937D-AB0C0AE8367F.3.videofx"];
    
    
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
