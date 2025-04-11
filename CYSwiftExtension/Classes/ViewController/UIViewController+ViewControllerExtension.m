//
//  UIViewController+ViewControllerExtension.m
//  CYSwiftExtension
//
//  Created by Yu Chen  on 2025/3/2.
//

#import "UIViewController+ViewControllerExtension.h"
#import "NSString+StringExtension.h"

@implementation UIViewController (ViewControllerExtension)

- (void)showSystemStyleSettingAlert:(NSString *)content okTitle:(NSString *)ok cancelTitle:(NSString *)cancel {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *okTitle = [NSString isEmptyString:ok] ? @"OK" : ok;
    NSString *cancelTitle = [NSString isEmptyString:cancel] ? @"Cancel" : cancel;
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}

- (BOOL)shouldPop {
    return YES;
}

@end
