#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    UILabelCountingMethodEaseInOut,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodLinear
} UILabelCountingMethod;

typedef NSString* (^UICountingLabelFormatBlock)(float value);
typedef NSAttributedString* (^UICountingLabelAttributedFormatBlock)(float value);

@interface UICountingLabel : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) UILabelCountingMethod method;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, copy) UICountingLabelFormatBlock formatBlock;
@property (nonatomic, copy) UICountingLabelAttributedFormatBlock attributedFormatBlock;
@property (nonatomic, copy) void (^completionBlock)();

-(void)countFrom:(float)startValue to:(float)endValue;
-(void)countFrom:(float)startValue to:(float)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromCurrentValueTo:(float)endValue;
-(void)countFromCurrentValueTo:(float)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromZeroTo:(float)endValue;
-(void)countFromZeroTo:(float)endValue withDuration:(NSTimeInterval)duration;

- (CGFloat)currentValue;

@end

