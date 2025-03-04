//
//  JCAPPURLMacroHeader.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#ifndef JCAPPURLMacroHeader_h
#define JCAPPURLMacroHeader_h

#import <UIKit/UIKit.h>
#import "APPNetResponseModel.h"

#pragma mark - URL -- TODO 正式地址要替换
#if DEBUG
static NSString * _Nullable const NET_REQUEST_BASE_URL = @"http://8.212.182.12:8749/quen";
#else
static NSString * _Nullable const NET_REQUEST_BASE_URL = @"https://app.fintopia-lending.com/scale";
#endif

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

#endif /* JCAPPURLMacroHeader_h */
