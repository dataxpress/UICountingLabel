#import "UICountingLabel.h"

#if !__has_feature(objc_arc)
#error UICountingLabel is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#pragma mark - UILabelCounter

// This whole class & subclasses are private to UICountingLabel, which is why they are declared here in the .m file

@interface UILabelCounter : NSObject

-(float)update:(float)t;

@property float rate;

@end

@interface UILabelCounterLinear : UILabelCounter

@end

@interface UILabelCounterEaseIn : UILabelCounter

@end

@interface UILabelCounterEaseOut : UILabelCounter

@end

@interface UILabelCounterEaseInOut : UILabelCounter

@end

@implementation  UILabelCounter

-(float)update:(float)t{
    return 0;
}

@end

@implementation UILabelCounterLinear

-(float)update:(float)t
{
    return t;
}

@end

@implementation UILabelCounterEaseIn

-(float)update:(float)t
{
    return powf(t, self.rate);
}

@end

@implementation UILabelCounterEaseOut

-(float)update:(float)t{
    return 1.0-powf((1.0-t), self.rate);
}

@end

@implementation UILabelCounterEaseInOut

-(float) update: (float) t
{
	int sign =1;
	int r = (int) self.rate;
	if (r % 2 == 0)
		sign = -1;
	t *= 2;
	if (t < 1)
		return 0.5f * powf (t, self.rate);
	else
		return sign*0.5f * (powf (t-2, self.rate) + sign*2);
}

@end

#pragma mark - UICountingLabel

@interface UICountingLabel ()

@property float startingValue;
@property float destinationValue;
@property NSTimeInterval progress;
@property NSTimeInterval lastUpdate;
@property NSTimeInterval totalTime;
@property float easingRate;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) UILabelCounter *counter;

@end

@implementation UICountingLabel

-(void)countFrom:(float)value to:(float)endValue {
    
    if (self.animationDuration == 0.0f) {
        self.animationDuration = 2.0f;
    }
    
    [self countFrom:value to:endValue withDuration:self.animationDuration];
}

-(void)countFrom:(float)startValue to:(float)endValue withDuration:(NSTimeInterval)duration {
    
    self.startingValue = startValue;
    self.destinationValue = endValue;
    
    // remove any (possible) old timers
    [self.timer invalidate];
    self.timer = nil;
    
    if (duration == 0.0) {
        // No animation
        [self setTextValue:endValue];
        [self runCompletionBlock];
        return;
    }

    self.easingRate = 3.0f;
    self.progress = 0;
    self.totalTime = duration;
    self.lastUpdate = [NSDate timeIntervalSinceReferenceDate];

    if(self.format == nil)
        self.format = @"%f";

    switch(self.method)
    {
        case UILabelCountingMethodLinear:
            self.counter = [[UILabelCounterLinear alloc] init];
            break;
        case UILabelCountingMethodEaseIn:
            self.counter = [[UILabelCounterEaseIn alloc] init];
            break;
        case UILabelCountingMethodEaseOut:
            self.counter = [[UILabelCounterEaseOut alloc] init];
            break;
        case UILabelCountingMethodEaseInOut:
            self.counter = [[UILabelCounterEaseInOut alloc] init];
            break;
    }

    self.counter.rate = 3.0f;

    NSTimer *timer = [NSTimer timerWithTimeInterval:(1.0f/30.0f) target:self selector:@selector(updateValue:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    self.timer = timer;
}

- (void)countFromCurrentValueTo:(float)endValue {
    [self countFrom:[self currentValue] to:endValue];
}

- (void)countFromCurrentValueTo:(float)endValue withDuration:(NSTimeInterval)duration {
    [self countFrom:[self currentValue] to:endValue withDuration:duration];
}

- (void)countFromZeroTo:(float)endValue {
    [self countFrom:0.0f to:endValue];
}

- (void)countFromZeroTo:(float)endValue withDuration:(NSTimeInterval)duration {
    [self countFrom:0.0f to:endValue withDuration:duration];
}

- (void)updateValue:(NSTimer *)timer {
    
    // update progress
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    self.progress += now - self.lastUpdate;
    self.lastUpdate = now;
    
    if (self.progress >= self.totalTime) {
        [self.timer invalidate];
        self.timer = nil;
        self.progress = self.totalTime;
    }
    
    [self setTextValue:[self currentValue]];
    
    if (self.progress == self.totalTime) {
        [self runCompletionBlock];
    }
}

- (void)setTextValue:(float)value
{
    if (self.attributedFormatBlock != nil) {
        self.attributedText = self.attributedFormatBlock(value);
    }
    else if(self.formatBlock != nil)
    {
        self.text = self.formatBlock(value);
    }
    else
    {
        // check if counting with ints - cast to int
        if([self.format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound || [self.format rangeOfString:@"%(.*)i"].location != NSNotFound )
        {
            self.text = [NSString stringWithFormat:self.format,(int)value];
        }
        else
        {
            self.text = [NSString stringWithFormat:self.format,value];
        }
    }
}

- (void)setFormat:(NSString *)format {
    _format = format;
    // update label with new format
    [self setTextValue:self.currentValue];
}

- (void)runCompletionBlock {
    
    if (self.completionBlock) {
        self.completionBlock();
        self.completionBlock = nil;
    }
}

- (CGFloat)currentValue {
    
    if (self.progress >= self.totalTime) {
        return self.destinationValue;
    }
    
    CGFloat percent = self.progress / self.totalTime;
    CGFloat updateVal = [self.counter update:percent];
    return self.startingValue + (updateVal * (self.destinationValue - self.startingValue));
}

@end
