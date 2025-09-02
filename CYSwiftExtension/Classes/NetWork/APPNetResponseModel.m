//
//  JCAPPNetResponseModel.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "APPNetResponseModel.h"
#import <YYKit/NSObject+YYModel.h>

@implementation APPNetResponseParsingConfig

+ (instancetype)parsingConfig {
    static APPNetResponseParsingConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (config == nil) {
            config = [[APPNetResponseParsingConfig alloc] init];
        }
    });
    
    return config;
}

@end

@interface APPNetResponseModel ()<YYModel>

@end

@implementation APPNetResponseModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"prize": APPNetResponseParsingConfig.parsingConfig.statusCodeKey,
             @"nobel": APPNetResponseParsingConfig.parsingConfig.serviceTipKey,
             @"awarded": APPNetResponseParsingConfig.parsingConfig.dataKey};
}

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
