#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    UILabelCountingMethodLinear,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodEaseInOut
} UILabelCountingMethod;

@interface UICountingLabel : UILabel

-(void)setValue:(int)value;
-(void)setValue:(int)value withCountingMethod:(UILabelCountingMethod)countingMethod;
-(void)setValue:(int)value withCountingMethod:(UILabelCountingMethod)countingMethod andDuration:(NSTimeInterval)duration;

@end

