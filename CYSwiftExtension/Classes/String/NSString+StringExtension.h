//
//  NSString+StringExtension.h
//  CYSwiftExtension
//
//  Created by Yu Chen  on 2025/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (StringExtension)

+ (BOOL)isEmptyString:(NSString *)str;
- (NSString *)maskPhoneNumber;
- (NSString *)unpackingURLParameters;

@end

NS_ASSUME_NONNULL_END
