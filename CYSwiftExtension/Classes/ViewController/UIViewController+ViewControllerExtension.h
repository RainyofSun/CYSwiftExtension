//
//  UIViewController+ViewControllerExtension.h
//  CYSwiftExtension
//
//  Created by Yu Chen  on 2025/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ViewControllerExtension)

- (void)showSystemStyleSettingAlert:(NSString *)content okTitle:(NSString * _Nullable )ok cancelTitle:(NSString * _Nullable )cancel;

@end

NS_ASSUME_NONNULL_END
