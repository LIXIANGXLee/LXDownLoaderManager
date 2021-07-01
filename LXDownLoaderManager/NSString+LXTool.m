//
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import "NSString+LXTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

/// md5转换
- (NSString *)lx_md5 {
    
    if (LX_OBJC_ISEMPTY(self)) { return @""; }
    
    const char *data = self.UTF8String;
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, (CC_LONG)strlen(data), md);
    NSMutableString *result = [NSMutableString
                               stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", md[i]];
    }
    return result;
}

- (BOOL)isValidURL {
    if (LX_OBJC_ISEMPTY(self)) { return NO; }
    
    NSString *pattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    NSRegularExpression *regex = [[NSRegularExpression alloc]
                                  initWithPattern:pattern options:0 error:nil];
    NSArray *regexArray = [regex matchesInString:self options:0
                                           range:NSMakeRange(0, self.length)];
    return (regexArray.count > 0) ;
}

@end
