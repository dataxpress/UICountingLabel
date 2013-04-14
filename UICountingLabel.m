#import "UICountingLabel.h"


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

@property (nonatomic, retain) UILabelCounter* counter;

@end

@implementation UICountingLabel

-(void)setValue:(float)value
{
    [self setValue:value withCountingMethod:UILabelCountingMethodEaseInOut andDuration:2.0f];
}

-(void)setValue:(float)value withCountingMethod:(UILabelCountingMethod)countingMethod
{
    [self setValue:value withCountingMethod:countingMethod andDuration:2.0f];
}

-(void)setValue:(float)value withCountingMethod:(UILabelCountingMethod)countingMethod andDuration:(NSTimeInterval)duration
{
    
    self.easingRate = 3.0f;
    self.startingValue = [self.text intValue];
    self.destinationValue = value;
    self.progress = 0;
    self.totalTime = duration;
    self.lastUpdate = [NSDate timeIntervalSinceReferenceDate];

    switch(countingMethod)
    {
        case UILabelCountingMethodLinear:
            self.counter = [[[UILabelCounterLinear alloc] init] autorelease];
            break;
        case UILabelCountingMethodEaseIn:
            self.counter = [[[UILabelCounterEaseIn alloc] init] autorelease];
            break;
        case UILabelCountingMethodEaseOut:
            self.counter = [[[UILabelCounterEaseOut alloc] init] autorelease];
            break;
        case UILabelCountingMethodEaseInOut:
            self.counter = [[[UILabelCounterEaseInOut alloc] init] autorelease];
            break;
    }
    
    self.counter.rate = 3.0f;
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:(1.0f/30.0f) target:self selector:@selector(updateValue:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)updateValue:(NSTimer*)timer
{
    // update progress
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    self.progress += now - self.lastUpdate;
    self.lastUpdate = now;
    
    if(self.progress > self.totalTime)
    {
        [timer invalidate];
        self.progress = self.totalTime;
    }
    
    float percent = self.progress / self.totalTime;
    float updateVal =[self.counter update:percent];
    float value =  self.startingValue +  (updateVal * (self.destinationValue - self.startingValue));
    
    
    
    self.text = [NSString stringWithFormat:_format,value];
    
}

-(void)dealloc
{
    [_counter release];
    [_format release];
    [super dealloc];
}

@end
