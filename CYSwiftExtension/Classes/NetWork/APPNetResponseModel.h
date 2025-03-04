//
//  JCAPPNetRequestModel.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 网络请求类型
 */
typedef NS_ENUM(NSInteger,AFNRequestType) {
    AFNRequestType_Get,             /// get请求
    AFNRequestType_Post,            /// post请求
    AFNRequestType_Upload,          /// 上传图片
    AFNRequestType_Download,        /// 文件下载
};

@interface APPNetResponseModel : NSObject

@property (nonatomic, assign) NSInteger prize;
@property (nonatomic, copy) NSString *nobel;
@property (nonatomic, strong) id awarded;
@property (nonatomic, strong) NSError *reqeustError;

@end

@interface APPSuccessResponse : NSObject

/// 字典模型
@property(nonatomic, strong) NSDictionary * _Nullable jsonDict;
/// 数组模型
@property(nonatomic, strong) NSArray * _Nullable jsonArray;
/// 请求的消息 --> 服务器返回的消息
@property(nonatomic, copy) NSString * _Nullable responseMsg;

@end

@interface NetworkRequestConfig : NSObject

/// 请求类型
@property(nonatomic, assign) AFNRequestType requestType;
/// 请求地址
@property(nonatomic, copy) NSString * _Nonnull requestURL;
/// 请求参数
@property(nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable requestParams;

/// 默认请求方式为 Post 请求
+ (instancetype)defaultRequestConfig:(NSString *)requestURL requestParams:(NSDictionary <NSString *, NSString *> * _Nullable)params;

@end
NS_ASSUME_NONNULL_END
