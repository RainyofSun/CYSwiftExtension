//
//  JCAPPPublicParams.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "APPPublicParams.h"
#import <YYKit/UIDevice+YYAdd.h>
#import "NSString+JCAPPStringExtension.h"
#import "UIDevice+JCAPPDeviceExtension.h"
#import "JoyCash-Swift.h"
#import <AdSupport/AdSupport.h>
#import "JCAPPDeviceAuthorizationTool.h"

@implementation APPPublicParams

+ (NSString *)splicingPublicParams:(NSString *)requestURL {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *deviceName = [[UIDevice currentDevice] machineModel];
    NSString *idfvStr = [[UIDevice currentDevice] readIDFVFormDeviceKeyChain];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *loginToken = JCAPPPublic.shared.appLoginInfo.any;
    NSString *IDFAStr = [[JCAPPDeviceAuthorizationTool authorization] ATTTrackingStatus] == ATTrackingManagerAuthorizationStatusAuthorized ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : @"";
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:requestURL];
    NSMutableArray<NSURLQueryItem *>* url_components = [NSMutableArray array];
    if (![NSString isEmptyString:appVersion]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"carbon" value:appVersion]];
    }
    
    if (![NSString isEmptyString:deviceName]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"lithium" value:deviceName]];
    }
    
    if (![NSString isEmptyString:idfvStr]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"potentially" value:idfvStr]];
    }
    
    if (![NSString isEmptyString:systemVersion]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"could" value:systemVersion]];
    }
    
    if (![NSString isEmptyString:loginToken]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"any" value:loginToken]];
    }
    
    if (![NSString isEmptyString:IDFAStr]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"ratio" value:IDFAStr]];
    }
    
    [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"chip" value:[NSString stringWithFormat:@"%ld", JCAPPPublic.shared.countryCode]]];
    
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

+ (NSArray<NSArray<NSString *> *>*)separamtionRequestURLParameter:(NSString *)requestURL {
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
