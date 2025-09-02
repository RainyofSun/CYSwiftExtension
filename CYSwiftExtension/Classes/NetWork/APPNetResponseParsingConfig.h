//
//  APPNetResponseParsingConfig.h
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPNetResponseParsingConfig : NSObject

/// 状态码 Key
@property (nonatomic, copy) NSString *statusCodeKey;
/// 服务器返回的提示语
@property (nonatomic, copy) NSString *serviceTipKey;
/// 服务器返回的数据
@property (nonatomic, copy) NSString *dataKey;

+ (instancetype)parsingConfig;

+ (void)setParsingConfig:(NSString *)statusCodeKey service:(NSString *)serviceTipKey data:(NSString *)dataKey;

@end

NS_ASSUME_NONNULL_END
