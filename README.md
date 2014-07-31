# UICountingLabel ####

Adds animated counting support to `UILabel`. 

## CocoaPods ######
UICountingLabel is available on CocoaPods.
Add this to your Podfile:

`pod 'UICountingLabel'`

And then run:

`$ pod install`

## Setup ######
Simply initialize a `UICountingLabel` the same way you set up a regular `UILabel`:

    UICountingLabel* myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    [self.view addSubview:myLabel];
    [myLabel release];

You can also add it to your XIB file, just make sure you set the class type to `UICountingLabel` instead of `UILabel` and be sure to `#import "UICountingLabel.h"` in the header file.

## Use #####

Set the format of your label.  This will be filled with a single int or float (depending on how you format it) when it updates:

    myLabel.format = @"%d";
    
Optionally, set the mode.  The default is `UILabelCountingMethodEaseInOut`, which will start slow, speed up, and then slow down as it reaches the end.  Other options are described below in the Methods section.

    myLabel.method = UILabelCountingMethodLinear;

When you want the label to start counting, just call:

    [myLabel countFrom:50 to:100];

You can also specify the duration.  The default is 2.0 seconds.

    [myLabel countFrom:50 to:100 withDuration:5.0f];

Additionally, there is `animationDuration` property which you can use to override the default animation duration.

    myLabel.animationDuration = 1.0;

You can use common convinient methods for counting, such as:

    [myLabel countFromCurrentValueTo:100];
    [myLabel countFromZeroTo:100];
    
Behind the scenes, these convinient methods use one base method, which has the following full signature:
    
    [myLabel     countFrom:(float)startValue 
                        to:(float)endValue 
              withDuration:(NSTimeInterval)duration];

You can get current value of your label using `-currentValue` method (works correctly in the process of animation too):

    CGFloat currentValue = [myLabel currentValue];

## Formats #####

When you set the `format` property, the label will look for the presence of `%(.*)d` or `%(.*)i`, and if found, will cast the value to `int` before formatting the string.  Otherwise, it will format it using a `float`.  

If you're using a `float` value, it's recommended to limit the number of digits with a format string, such as `@"%.1f"` for one decimal place.

Because it uses the standard `stringWithFormat:` method, you can also include arbitrary text in your format, such as `@"Points: %i"`.

## Modes #####
There are currently four modes of counting.

### `UILabelCountingMethodLinear` #####
Counts linearly from the start to the end.  

### `UILabelCountingMethodEaseIn` #####
Ease In starts out slow and speeds up counting as it gets to the end, stopping suddenly at the final value.

### `UILabelCountingMethodEaseOut` #####
Ease Out starts out fast and slows down as it gets to the destination value.  

### `UILabelCountingMethodEaseInOut` #####
Ease In/Out starts out slow, speeds up towards the middle, and then slows down as it approaches the destination.  It is a nice, smooth curve that looks great, and is the default method.
