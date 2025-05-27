//
//  APPNetRequestManager.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "APPNetRequestManager.h"
#import "APPPublicParams.h"
#import <AFNetworking/AFNetworking.h>
#import "APPNetRequestConfig.h"
#import "APPNetResponseModel.h"
#import "NSString+StringExtension.h"
#import <YYKit/NSObject+YYModel.h>
#import "UIDevice+DeviceExtension.h"
#import <Toast/Toast.h>

@implementation APPNetRequestManager

+ (NSURLSessionTask *)AFNReqeustType:(NetworkRequestConfig *)requestConfig success:(SuccessCallBack)success failure:(FailureCallBack)failure {
    NSString *requestUrl = [[APPPublicParams requestParams] splicingPublicParams:requestConfig.requestURL];
# if DEBUG
    NSLog(@"RequestURL = \n %@ \n Params = \n %@ \n End ---------", requestConfig.requestURL, requestConfig.requestParams);
#endif
    if (requestConfig.requestType == AFNRequestType_Get) {
        return [[APPNetRequestConfig requestConfig].manager GET:requestUrl parameters:requestConfig.requestParams headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            APPNetResponseModel *responseModel = [self jsonToModel:responseObject requestTask:task];
            if (responseModel == nil || [responseModel isEqual:[NSNull null]] || (responseModel.reqeustError && failure != nil)) {
                failure(nil, responseModel.reqeustError);
            } else {
                APPSuccessResponse *response = [[APPSuccessResponse alloc] init];
                response.responseMsg = responseModel.nobel;
                if ([responseModel.awarded isKindOfClass:[NSDictionary class]]) {
                    response.jsonDict = (NSDictionary *)responseModel.awarded;
                }
                
                if ([responseModel.awarded isKindOfClass:[NSArray class]]) {
                    response.jsonArray = (NSArray *)responseModel.awarded;
                }
                success(task, response);
            }
        } failure: failure];
    } else if (requestConfig.requestType == AFNRequestType_Post) {
        return [[APPNetRequestConfig requestConfig].manager POST:requestUrl parameters:requestConfig.requestParams headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            APPNetResponseModel *responseModel = [self jsonToModel:responseObject requestTask:task];
            if (responseModel == nil || [responseModel isEqual:[NSNull null]] || (responseModel.reqeustError && failure != nil)) {
                failure(nil, responseModel.reqeustError);
            } else {
                APPSuccessResponse *response = [[APPSuccessResponse alloc] init];
                response.responseMsg = responseModel.nobel;
                if ([responseModel.awarded isKindOfClass:[NSDictionary class]]) {
                    response.jsonDict = (NSDictionary *)responseModel.awarded;
                }
                
                if ([responseModel.awarded isKindOfClass:[NSArray class]]) {
                    response.jsonArray = (NSArray *)responseModel.awarded;
                }
                success(task, response);
            }
        } failure: failure];
    } else if (requestConfig.requestType == AFNRequestType_Upload) {
        return [[APPNetRequestConfig requestConfig].manager POST:requestUrl parameters:requestConfig.requestParams headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [requestConfig.requestParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj hasPrefix:@"File"] || [obj hasPrefix:@"/var/mobile"]) {
                    NSArray<NSString *>* strArray = [obj componentsSeparatedByString:@"$"];
                    NSData *data = [NSData dataWithContentsOfFile:strArray.lastObject];
                    [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/png"];
                    *stop = YES;
                }
            }];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            APPNetResponseModel *responseModel = [self jsonToModel:responseObject requestTask:task];
            if (responseModel == nil || [responseModel isEqual:[NSNull null]] || (responseModel.reqeustError && failure != nil)) {
                failure(nil, responseModel.reqeustError);
            } else {
                APPSuccessResponse *response = [[APPSuccessResponse alloc] init];
                response.responseMsg = responseModel.nobel;
                if ([responseModel.awarded isKindOfClass:[NSDictionary class]]) {
                    response.jsonDict = (NSDictionary *)responseModel.awarded;
                }
                
                if ([responseModel.awarded isKindOfClass:[NSArray class]]) {
                    response.jsonArray = (NSArray *)responseModel.awarded;
                }
                success(task, response);
            }
        } failure: failure];
    } else {
        NSURLSessionDownloadTask *downloadTask = [[APPNetRequestConfig requestConfig].manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
            return [documentsDirectoryPath URLByAppendingPathComponent:[response.suggestedFilename lastPathComponent]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSData *fileData = nil;
            APPSuccessResponse *res = [[APPSuccessResponse alloc] init];
            @try {
                fileData = [NSData dataWithContentsOfURL:filePath];
                if (fileData != nil) {
                    NSString *fileContent = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
                    res.responseMsg = fileContent;
                }
            } @catch (NSException *exception) {
//                DDLogError(exception);
            } @finally {
                success(nil, res);
            }
        }];
        
        [downloadTask resume];
        
        return downloadTask;
    }
}

+ (nullable APPNetResponseModel *)jsonToModel:(id)responseObject requestTask:(NSURLSessionTask *)task {
    NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
    NSLog(@"RequestURL = \n %@ \n Response = \n %@ \nEnd -------", task.currentRequest.URL.absoluteString, jsonStr);
#endif
    APPNetResponseModel *responseModel = [APPNetResponseModel modelWithJSON:jsonStr];
    if ([NSString isEmptyString:jsonStr] || responseModel == nil || [responseModel isEqual:[NSNull null]]) {
        return nil;
    }
    
    if (responseModel.prize == -2) {
        responseModel.reqeustError = [[NSError alloc] initWithDomain:@"request.error" code:responseModel.prize userInfo:@{NSLocalizedFailureReasonErrorKey: responseModel.nobel}];
        // 登录失效.重新登录
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSNotificationName)APP_LOGIN_EXPIRED_NOTIFICATION object:nil];
        return responseModel;
    }
    
    if (responseModel.prize != 0) {
        responseModel.reqeustError = [[NSError alloc] initWithDomain:@"request.error" code:responseModel.prize userInfo:@{NSLocalizedFailureReasonErrorKey: responseModel.nobel}];
        if (![NSString isEmptyString:responseModel.nobel]) {
            [[UIDevice currentDevice].keyWindow makeToast: responseModel.nobel];
        }
        return responseModel;
    }
    
    return responseModel;
}

@end
