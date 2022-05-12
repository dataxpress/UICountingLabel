@import Foundation;
@import CoreGraphics;

#if TARGET_OS_IOS
@import UIKit;

typedef NS_ENUM(NSInteger, UILabelCountingMethod) {
    UILabelCountingMethodEaseInOut,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodLinear,
    UILabelCountingMethodEaseInBounce,
    UILabelCountingMethodEaseOutBounce
};

typedef NSString* (^UICountingLabelFormatBlock)(CGFloat value);
typedef NSAttributedString* (^UICountingLabelAttributedFormatBlock)(CGFloat value);

@interface UICountingLabel : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) UILabelCountingMethod method;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, copy) UICountingLabelFormatBlock formatBlock;
@property (nonatomic, copy) UICountingLabelAttributedFormatBlock attributedFormatBlock;
@property (nonatomic, copy) void (^completionBlock)(void);

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue;
-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromCurrentValueTo:(CGFloat)endValue;
-(void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromZeroTo:(CGFloat)endValue;
-(void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (CGFloat)currentValue;

@end

#endif //TARGET_OS_IOS
