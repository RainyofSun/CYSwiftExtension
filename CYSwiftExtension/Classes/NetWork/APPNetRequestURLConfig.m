//
//  APPNetRequestURLConfig.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "APPNetRequestURLConfig.h"
#import "NSString+JCAPPStringExtension.h"
#import "JCAPPURLMacroHeader.h"

@interface APPNetRequestURLConfig ()

@property (nonatomic, copy) NSString *requestDomainURL;
@property (nonatomic, strong) NSMutableArray<NSString *>* usedDomainURLs;

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
        return [NSURL URLWithString:NET_REQUEST_BASE_URL];
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
