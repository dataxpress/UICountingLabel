#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    UILabelCountingMethodEaseInOut,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodLinear
} UILabelCountingMethod;

@interface UICountingLabel : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) UILabelCountingMethod method;

-(void)countFrom:(float)startValue to:(float)endValue;
-(void)countFrom:(float)startValue to:(float)endValue withDuration:(NSTimeInterval)duration;

@end

