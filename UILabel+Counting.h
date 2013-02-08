#import <Foundation/Foundation.h>

typedef enum {
    UILabelCountingMethodLinear,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodEaseInOut
} UILabelCountingMethod;

@interface UILabel (Counting)

@property UILabelCountingMethod countingMethod;

@end

