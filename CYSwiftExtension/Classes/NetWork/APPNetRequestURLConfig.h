//
//  JCAPPNetRequestURLConfig.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPNetRequestURLConfig : NSObject

+ (instancetype)urlConfig;
+ (void)setNetworkDebugRequestURL:(NSString *)debugUrl releaseUrl:(NSString *)releaseUrl;
+ (BOOL)reloadNetworkRequestDomainURL:(NSString *)url;
+ (void)clearDomainURLCache;

- (BOOL)setNewNetworkRequestDomainURL:(NSString *)url;
- (NSURL *)networkRequestURL;

@end

NS_ASSUME_NONNULL_END
