//
//  DeviceAuthorizationTool.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "DeviceAuthorizationTool.h"
#import <Photos/Photos.h>
#import "UIDevice+DeviceExtension.h"
#import "UIViewController+ViewControllerExtension.h"

@interface DeviceAuthorizationTool ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation DeviceAuthorizationTool

+ (instancetype)authorization {
    static DeviceAuthorizationTool *au;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (au == nil) {
            au = [[DeviceAuthorizationTool alloc] init];
        }
    });
    
    return au;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL isEndable = [CLLocationManager locationServicesEnabled];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phoneOpenLocation = isEndable;
            });
        });
    }
    return self;
}

- (VCAPPAuthorizationStatus)locationAuthorization {
    if (!self.phoneOpenLocation) {
        return Disable;
    }
    
    switch ([self.locationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
            return Denied;
        case kCLAuthorizationStatusAuthorizedAlways:
            return Authorized;
        case kCLAuthorizationStatusRestricted:
            return Restricted;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return Limited;
        case kCLAuthorizationStatusNotDetermined:
            return NotDetermined;
        default:
            return Denied;
    }
}

- (ATTrackingManagerAuthorizationStatus)ATTTrackingStatus {
    return [ATTrackingManager trackingAuthorizationStatus];
}

- (void)requestDevicePhotoAuthrization:(VCAPPPhotoAccessLevel)level completeHandler:(void (^)(BOOL))handler {
    [PHPhotoLibrary requestAuthorizationForAccessLevel:level == AddOnly ? PHAccessLevelAddOnly : PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
        handler(status == PHAuthorizationStatusAuthorized);
    }];
}

- (void)requestDeviceCameraAuthrization:(void (^)(BOOL))handler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
}

- (void)requestDeviceLocationAuthrization:(VCAPPLocationAuthLevel)level {
    if (level == WhenInUse) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)requestDeviceIDFAAuthrization:(void (^)(BOOL))handler {
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        handler(status == ATTrackingManagerAuthorizationStatusAuthorized);
    }];
}

+ (NSArray<NSString *> *)deviceLocationInfo {
    return @[[NSString stringWithFormat:@"%f", [DeviceAuthorizationTool authorization].location.coordinate.latitude],
             [NSString stringWithFormat:@"%f", [DeviceAuthorizationTool authorization].location.coordinate.longitude]];
}

- (void)startDeviceLocation {
    if (self.phoneOpenLocation) {
        CLAuthorizationStatus status = [self.locationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
            [[UIDevice currentDevice].keyWindow.rootViewController showSystemStyleSettingAlert:@"The current application collects your location information, uses it for loan risk assessment, and recommends personalized products to you. You can open Settings-Privacy System and set it to off at any time." okTitle:nil cancelTitle:nil];
            return;
        }
        
        [self.locationManager startUpdatingLocation];
    } else {
        if (![CLLocationManager locationServicesEnabled]) {
            [[UIDevice currentDevice].keyWindow.rootViewController showSystemStyleSettingAlert:@"The current application collects your location information, uses it for loan risk assessment, and recommends personalized products to you. You can open Settings-Privacy System and set it to off at any time." okTitle:nil cancelTitle:nil];
            return;
        }
        
        if ([self locationAuthorization] == NotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)stopDeviceLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void)requestDeviceLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)geocoderInfoForLocation:(CLLocation *)location {    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        weakSelf.placeMark = placemarks.firstObject;
        weakSelf.location = location;
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败了 --- %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    if (location == nil) {
        return;
    }
    
    NSLog(@"------ 埋点定位 -- %f - %f", location.coordinate.latitude, location.coordinate.longitude);
    [self geocoderInfoForLocation:location];
    [self.locationManager stopUpdatingLocation];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = 0.01;
    }
    
    return _locationManager;
}

@end
