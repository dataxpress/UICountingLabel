#import "UICountingLabel.h"

@interface UICountingLabel ()

@property int startingValue;
@property int destinationValue;
@property NSTimeInterval progress;
@property NSTimeInterval lastUpdate;
@property NSTimeInterval totalTime;


@property UILabelCountingMethod countingMethod;
@end

@implementation UICountingLabel

-(void)setValue:(int)value
{
    [self setValue:value withCountingMethod:UILabelCountingMethodLinear andDuration:1.0f];
}

-(void)setValue:(int)value withCountingMethod:(UILabelCountingMethod)countingMethod
{
    [self setValue:value withCountingMethod:countingMethod andDuration:1.0f];
}

-(void)setValue:(int)value withCountingMethod:(UILabelCountingMethod)countingMethod andDuration:(NSTimeInterval)duration
{
    self.startingValue = [self.text intValue];
    self.destinationValue = value;
    self.progress = 0;
    self.totalTime = duration;
    self.lastUpdate = [NSDate timeIntervalSinceReferenceDate];
    self.countingMethod = countingMethod;
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
    int value = 0;
    switch (self.countingMethod)
    {
        case UILabelCountingMethodLinear:
            value = self.startingValue + (int)((float)(self.destinationValue - self.startingValue) * percent);
            break;
        default:
            value = 0;
            break;
    }
    
    self.text = [NSString stringWithFormat:@"%d",value];
    
}

-(void)dealloc
{
    [super dealloc];
}

@end
