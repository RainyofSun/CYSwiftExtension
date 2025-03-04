//
//  UIDevice+JCAPPDeviceExtension.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (JCAPPDeviceExtension)

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

@end

NS_ASSUME_NONNULL_END
