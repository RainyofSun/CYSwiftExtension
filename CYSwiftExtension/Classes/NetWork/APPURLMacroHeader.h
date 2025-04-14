//
//  APPURLMacroHeader.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#ifndef APPURLMacroHeader_h
#define APPURLMacroHeader_h

#import <UIKit/UIKit.h>
#import "APPNetResponseModel.h"

/*
    block 回调
 */
typedef void(^ _Nonnull SuccessCallBack)(NSURLSessionDataTask * _Nonnull task, APPSuccessResponse * _Nonnull responseObject);
typedef void(^ _Nullable FailureCallBack)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error);

/*
    登录态通知
 */
/// 登录状态失效
static NSString * _Nonnull const APP_LOGIN_EXPIRED_NOTIFICATION = @"com.mx.notification.name.login.expired";
/// 登录成功
static NSString * _Nonnull const APP_LOGIN_SUCCESS_NOTIFICATION = @"com.mx.notification.name.login.success";

#endif /* APPURLMacroHeader_h */
