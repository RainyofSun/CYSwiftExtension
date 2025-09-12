//
//  JianBianLab.h
//  Dinero
//
//  Created by Yu Chen  on 2025/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JianBianLab : UILabel

/// 描边颜色
@property (nonatomic, strong) UIColor *strokeColor;

/// 描边宽度（正数只描边）
@property (nonatomic, assign) CGFloat strokeWidth;

/// 渐变颜色数组（至少两个 UIColor）
@property (nonatomic, strong) NSArray<UIColor *> *gradientColors;

@end

NS_ASSUME_NONNULL_END
