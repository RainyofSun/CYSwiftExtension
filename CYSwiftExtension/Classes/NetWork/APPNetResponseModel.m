//
//  JCAPPNetResponseModel.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "APPNetResponseModel.h"

@implementation APPNetResponseModel

@end

@implementation APPSuccessResponse



@end

@implementation NetworkRequestConfig

+ (instancetype)defaultRequestConfig:(NSString *)requestURL requestParams:(NSDictionary<NSString *,NSString *> *)params {
    NetworkRequestConfig *config = [[NetworkRequestConfig alloc] init];
    config.requestParams = params;
    config.requestURL = requestURL;
    config.requestType = AFNRequestType_Post;
    return config;
}

@end
