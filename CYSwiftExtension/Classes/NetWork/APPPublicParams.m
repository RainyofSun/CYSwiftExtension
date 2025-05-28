//
//  JCAPPPublicParams.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "APPPublicParams.h"
#import <YYKit/UIDevice+YYAdd.h>
#import "NSString+StringExtension.h"
#import "UIDevice+DeviceExtension.h"
#import <AdSupport/AdSupport.h>
#import "DeviceAuthorizationTool.h"
#import "APPURLMacroHeader.h"

@implementation APPPublicParamsKey



@end

@interface APPPublicParams ()

@property (nonatomic, strong) APPPublicParamsKey *_key_model;

@end

@implementation APPPublicParams

+ (instancetype)requestParams {
    static APPPublicParams *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (config == nil) {
            config = [[APPPublicParams alloc] init];
        }
    });
    
    return config;
}

- (void)appCommonParamsKeyModel:(APPPublicParamsKey *)keyModel {
    self._key_model = keyModel;
}

- (void)appUpdateLoginToken:(NSString *)token withContryCode:(NSString *)countryCode {
    if (self._key_model != nil) {
        if (![NSString isEmptyString:token]) {
            self._key_model.loginToken = token;
        }
        
        if (![NSString isEmptyString:countryCode]) {
            self._key_model.countryCode = countryCode;
        }
    }
}

- (NSString *)splicingPublicParams:(NSString *)requestURL {
    if (self._key_model == nil) {
        NSLog(@"ERROR: ------------- 请设置公共参数Key的集合 ----------------");
        return requestURL;
    }
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *deviceName = [[UIDevice currentDevice] machineModel];
    NSString *idfvStr = [[UIDevice currentDevice] readIDFVFormDeviceKeyChain];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *loginToken = self._key_model.loginToken;
    NSString *IDFAStr = [[DeviceAuthorizationTool authorization] ATTTrackingStatus] == ATTrackingManagerAuthorizationStatusAuthorized ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : APP_DEFAULT_IDFA_MARK;
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:requestURL];
    NSMutableArray<NSURLQueryItem *>* url_components = [NSMutableArray array];
    if (![NSString isEmptyString:appVersion]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:self._key_model.appVersionKey value:appVersion]];
    }
    
    if (![NSString isEmptyString:deviceName]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:self._key_model.deviceNameKey value:deviceName]];
    }
    
    if (![NSString isEmptyString:idfvStr]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:self._key_model.idfvKey value:idfvStr]];
    }
    
    if (![NSString isEmptyString:systemVersion]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:self._key_model.systemVersionKey value:systemVersion]];
    }
    
    if (![NSString isEmptyString:loginToken]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:self._key_model.loginTokenKey value:loginToken]];
    }
    
    if (![NSString isEmptyString:IDFAStr]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:self._key_model.idfaKey value:IDFAStr]];
    }
    
    if (![NSString isEmptyString:self._key_model.countryCode]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:self._key_model.countryCodeKey value:[NSString stringWithFormat:@"%@", self._key_model.countryCode]]];
    }
    
    if ([requestURL containsString:@"?"]) {
        NSArray<NSArray <NSString *>*>* argusArray = [self separamtionRequestURLParameter:requestURL];
        if (argusArray.count != 0) {
            [argusArray enumerateObjectsUsingBlock:^(NSArray<NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [url_components addObject:[[NSURLQueryItem alloc] initWithName:obj.firstObject value:obj.lastObject]];
            }];
        }
    }
    
    components.queryItems = url_components;
    
    return [NSString isEmptyString:components.URL.absoluteString] ? requestURL : components.URL.absoluteString;
}

- (NSArray<NSArray<NSString *> *>*)separamtionRequestURLParameter:(NSString *)requestURL {
    NSString *lastStr = [[requestURL componentsSeparatedByString:@"?"] lastObject];
    NSMutableArray<NSArray <NSString *>*>* argusArray = [NSMutableArray array];
    NSArray<NSString *>* params = [lastStr componentsSeparatedByString:@"&"];
    [params enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<NSString *>* tempArray = [obj componentsSeparatedByString:@"="];
        [argusArray addObject:tempArray];
    }];
    
    return argusArray;
}

@end
