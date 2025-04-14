//
//  UIDevice+JCAPPDeviceExtension.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (DeviceExtension)

- (NSString *)readIDFVFormDeviceKeyChain;
- (UIWindowScene *)activeScene;
- (UIWindow *)keyWindow;

- (NSArray <NSString *>*)appBattery;
- (NSString *)getSIMCardInfo;
- (NSString *)getNetconnType;
- (NSArray<NSString *> *)getWiFiInfo;
- (NSString *)getIPAddress;
+ (NSDictionary *)getAppDiskSize;
+ (NSString *)getFreeMemory;
+ (BOOL)getProxyStatus:(NSString *)url;
+ (BOOL)isVPNEnabled;
+ (CGFloat)app_safeDistanceTop;
+ (CGFloat)app_safeDistanceBottom;
+ (CGFloat)app_statusBarAndSafeAreaHeight;
+ (CGFloat)app_navigationBarHeight;
+ (CGFloat)app_navigationBarAndStatusBarHeight;
+ (CGFloat)app_tabbarHeight;
+ (CGFloat)app_tabbarAndSafeAreaHeight;

@end

NS_ASSUME_NONNULL_END
