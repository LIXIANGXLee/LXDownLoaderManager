//
//  NSString+MD5.h
//  LXDownLoaderModule
//
//  Created by Mac on 2020/5/3.
//  Copyright © 2020 李响. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LX_OBJC_ISEMPTY(objc) (objc == nil || [objc isEqual:[NSNull null]])

@interface NSString (MD5)

/**扩展 MD5*/
- (NSString *)lx_md5;

/**检查是否是有效的http或者https链接*/
- (BOOL)isValidURL;

@end

NS_ASSUME_NONNULL_END
