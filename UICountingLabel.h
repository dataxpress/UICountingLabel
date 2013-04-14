#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    UILabelCountingMethodLinear,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodEaseInOut
} UILabelCountingMethod;

@interface UICountingLabel : UILabel

@property (nonatomic, strong) NSString *format;

-(void)setValue:(float)value;
-(void)setValue:(float)value withCountingMethod:(UILabelCountingMethod)countingMethod;
-(void)setValue:(float)value withCountingMethod:(UILabelCountingMethod)countingMethod andDuration:(NSTimeInterval)duration;

@end

