//
//  JianBianLab.m
//  Dinero
//
//  Created by Yu Chen  on 2025/9/5.
//

#import "JianBianLab.h"

@implementation JianBianLab

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _strokeColor = [UIColor whiteColor];
        _strokeWidth = 2.0;
        _gradientColors = @[[UIColor redColor], [UIColor blueColor]];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.text.length == 0) return;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // === 1. 先画描边 ===
    if (self.strokeColor && self.strokeWidth > 0) {
        NSDictionary *strokeAttr = @{
            NSFontAttributeName : self.font,
            NSStrokeColorAttributeName : self.strokeColor,
            NSStrokeWidthAttributeName : @(self.strokeWidth)
        };
        [self.text drawInRect:self.bounds withAttributes:strokeAttr];
    }
    
    // === 2. 绘制渐变文字 ===
    // 生成文字 mask
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef maskContext = UIGraphicsGetCurrentContext();
    
    NSDictionary *textAttr = @{
        NSFontAttributeName : self.font,
        NSForegroundColorAttributeName : [UIColor blackColor] // mask 用黑色即可
    };
    [self.text drawInRect:self.bounds withAttributes:textAttr];
    
    CGImageRef textMask = CGBitmapContextCreateImage(maskContext);
    UIGraphicsEndImageContext();
    
    // clip 到 mask
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, textMask);
    
    // 渐变
    if (self.gradientColors.count >= 2) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSMutableArray *cgColors = [NSMutableArray array];
        for (UIColor *color in self.gradientColors) {
            [cgColors addObject:(id)color.CGColor];
        }
        CGFloat locations[self.gradientColors.count];
        for (NSInteger i = 0; i < self.gradientColors.count; i++) {
            locations[i] = (CGFloat)i / (self.gradientColors.count - 1);
        }
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)cgColors, locations);
        CGPoint start = CGPointMake(0, rect.size.height/2);
        CGPoint end = CGPointMake(rect.size.width, rect.size.height/2);
        CGContextDrawLinearGradient(context, gradient, start, end, 0);
        
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
    
    CGContextRestoreGState(context);
    CGImageRelease(textMask);
}

@end
