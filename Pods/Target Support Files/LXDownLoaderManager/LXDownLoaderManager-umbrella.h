#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LXDownLoader.h"
#import "LXDownLoaderManager.h"
#import "LXLoaderFile.h"
#import "NSString+MD5.h"

FOUNDATION_EXPORT double LXDownLoaderManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char LXDownLoaderManagerVersionString[];

