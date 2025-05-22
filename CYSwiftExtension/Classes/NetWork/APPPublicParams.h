//
//  APPPublicParams.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPPublicParamsKey : NSObject

@property (nonatomic, copy) NSString *appVersionKey;
@property (nonatomic, copy) NSString *deviceNameKey;
@property (nonatomic, copy) NSString *idfvKey;
@property (nonatomic, copy) NSString *systemVersionKey;
@property (nonatomic, copy) NSString *loginTokenKey;
@property (nonatomic, copy) NSString *loginToken;
@property (nonatomic, copy) NSString *idfaKey;
@property (nonatomic, copy) NSString *countryCodeKey;
@property (nonatomic, copy) NSString *countryCode;

@end

@interface APPPublicParams : NSObject

+ (instancetype)requestParams;

- (void)appCommonParamsKeyModel:(APPPublicParamsKey *)keyModel;
- (void)appUpdateLoginToken:(nullable NSString *)token withContryCode:(nullable NSString *)countryCode;

- (NSString *)splicingPublicParams:(NSString *)requestURL;

@end

NS_ASSUME_NONNULL_END
