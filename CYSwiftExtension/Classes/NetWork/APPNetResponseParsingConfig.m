//
//  APPNetResponseParsingConfig.m
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/9/1.
//

#import "APPNetResponseParsingConfig.h"

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

+ (void)setParsingConfig:(NSString *)statusCodeKey service:(NSString *)serviceTipKey data:(NSString *)dataKey {
    [APPNetResponseParsingConfig parsingConfig].statusCodeKey = statusCodeKey;
    [APPNetResponseParsingConfig parsingConfig].serviceTipKey = serviceTipKey;
    [APPNetResponseParsingConfig parsingConfig].dataKey = dataKey;
}

@end
