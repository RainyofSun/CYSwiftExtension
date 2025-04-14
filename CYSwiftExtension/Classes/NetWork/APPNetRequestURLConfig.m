//
//  APPNetRequestURLConfig.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "APPNetRequestURLConfig.h"
#import "NSString+StringExtension.h"
#import "APPURLMacroHeader.h"

@interface APPNetRequestURLConfig ()

@property (nonatomic, copy) NSString *requestDomainURL;
@property (nonatomic, strong) NSMutableArray<NSString *>* usedDomainURLs;
@property (nonatomic, copy) NSString *debugUrl;
@property (nonatomic, copy) NSString *releaseUrl;

@end

@implementation APPNetRequestURLConfig

+ (instancetype)urlConfig {
    static APPNetRequestURLConfig *url;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (url == nil) {
            url = [[APPNetRequestURLConfig alloc] init];
        }
    });
    
    return url;
}

+ (BOOL)reloadNetworkRequestDomainURL:(NSString *)url {
    return [[APPNetRequestURLConfig urlConfig] setNewNetworkRequestDomainURL:url];
}

+ (void)clearDomainURLCache {
    [[APPNetRequestURLConfig urlConfig].usedDomainURLs removeAllObjects];
}

+ (void)setNetworkDebugRequestURL:(NSString *)debugUrl releaseUrl:(NSString *)releaseUrl {
    [APPNetRequestURLConfig urlConfig].debugUrl = debugUrl;
    [APPNetRequestURLConfig urlConfig].releaseUrl = releaseUrl;
}

- (BOOL)setNewNetworkRequestDomainURL:(NSString *)url {
    if ([self.usedDomainURLs containsObject:url]) {
        return NO;
    }
    
    self.requestDomainURL = url;
    [self.usedDomainURLs addObject:url];
    NSLog(@"-------- 设置新的域名 = %@ success ---------", url);
    
    return YES;
}

- (NSURL *)networkRequestURL {
    if ([NSString isEmptyString:self.requestDomainURL]) {
        NSString *url = @"";
#if DEBUG
        url = self.debugUrl;
#else
        url = self.releaseUrl;
#endif
        if (![NSString isEmptyString:url]) {
            return [NSURL URLWithString:url];
        }
        
        return [NSURL URLWithString:@""];
    }
    
    return [NSURL URLWithString:self.requestDomainURL];
}

- (NSMutableArray<NSString *> *)usedDomainURLs {
    if (!_usedDomainURLs) {
        _usedDomainURLs = [NSMutableArray array];
    }
    
    return _usedDomainURLs;
}
@end
