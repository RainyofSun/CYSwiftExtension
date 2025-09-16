//
//  NSString+StringExtension.m
//  CYSwiftExtension
//
//  Created by Yu Chen  on 2025/3/2.
//

#import "NSString+StringExtension.h"

@implementation NSString (StringExtension)

+ (BOOL)isEmptyString:(NSString *)str {
    if ([str isEqual:[NSNull null]] || str == nil || str.length == 0) {
        return YES;
    }
    
    return NO;
}

- (NSString *)maskPhoneNumber {
    NSInteger start = 2;
    NSInteger end = 4;
    NSString *str = @"";
    for (int i = 0; i < (self.length - start - end); i ++) {
        str = [NSString stringWithFormat:@"%@*", str];
    }
    
    return [self stringByReplacingCharactersInRange:NSMakeRange(start, (self.length - start - end)) withString:str];;
}

- (NSString *)unpackingURLParameters {
    NSString *parsa = [[self componentsSeparatedByString:@"?"] lastObject];
    NSString *nexts = [[parsa componentsSeparatedByString:@"="] lastObject];
    return nexts;
}

@end
