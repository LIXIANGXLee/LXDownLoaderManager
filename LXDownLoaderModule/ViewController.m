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
//    [manager setMaxConcurrentCount:2];
    
    NSArray * arr = @[@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/BCD1FAAD-D5C5-468F-A4F2-1C2138F485C0.3.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/3F073D0E-FEF9-45AE-82E6-58DF220F07B8.6.videofx",
   
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/2ABB5A04-D2E0-4794-9338-03AD1663AE2A.2.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/91B91F8D-2C7D-4BAE-A869-CF4003BB2E70.1.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/35B954E1-8D38-40BC-A567-F6DA1D557950.2.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/F17F414B-B1E2-4FB8-BD29-FEFDA43FCB98.1.videofx",
  
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/0C6D17E4-1B59-42EA-937D-AB0C0AE8367F.3.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/66A7D54F-79C4-4DCC-82F7-F23949D92E0A.2.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/2704F14B-43A5-413B-9E5C-D1DB229BC0C7.5.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/895EFE2F-C116-4DBE-A244-67C6C26DC864.3.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/86FA5FB0-0611-48BB-A4F6-3DAE4F94174C.1.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/CF450CF5-36BB-4617-AB69-A8E813EECF9B.4.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/CCA0BCE3-BA0B-4A96-9F35-D9BC44A862D5.1.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/ABDB98D2-F83E-45DF-983E-775937D3A4E4.1.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/A13C3698-7257-49EE-948E-8D4F805DA1FC.1.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/B8D91810-03C7-4100-BEC6-3B832C0A3D01.2.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/2A86D624-BF4C-4389-83A1-7F293FA7660B.1.videofx",
                      @"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/8B952A30-CD2F-4E77-ABED-EC1DDF4AA67E.2.videofx"];
    
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
    
    NSLog(@"-----============%@",[manager getLocalDownloadPath:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/8B952A30-CD2F-4E77-ABED-EC1DDF4AA67E.2.videofx"]]);
    
    NSLog(@"-----============%ld",[manager getDownloadedLengthWithUrl:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/8B952A30-CD2F-4E77-ABED-EC1DDF4AA67E.2.videofx"]]);
    NSLog(@"-----============%ld",[manager isCheckUrlInLocal:[NSURL URLWithString:@"https://xxshowcdn.arworld.art/prod/source/douVideoPackage/8B952A30-CD2F-4E77-ABED-EC1DDF4AA67E.2.videofx"]]);

//    [LXLoaderFile clearDocument];

}


@end
