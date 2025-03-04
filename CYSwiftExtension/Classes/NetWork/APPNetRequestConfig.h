//
//  JCAPPNetRequestConfig.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPNetRequestConfig : NSObject

/** 网络请求管理 */
@property (nonatomic,strong) AFHTTPSessionManager* manager;

+ (instancetype)requestConfig;
+ (void)reloadNetworkRequestURL;
- (void)updateNetworkRequestURL;

@end

NS_ASSUME_NONNULL_END
