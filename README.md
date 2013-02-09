# UICountingLabel ####

Adds animated counting support to `UILabel`. 


## Setup ######
Simply initialize a `UICountingLabel` the same way you set up a regular UILabel:

    UICountingLabel* myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    [self.view addSubview:myLabel];
    [myLabel release];

You can also add it to your XIB file, just make sure you set the class type to `UICountingLabel` instead of `UILabel` and be sure to `#import "UICountingLabel.h"` in the header file.

## Use #####
When you want the label to start counting, set the value of the label to the initial value first:

    myLabel.text = @"0";

Then, call

    [myLabel setValue:(int)value withCountingMethod:(UILabelCountingMethod)countingMethod andDuration:(NSTimeInterval)duration];

Note that you can also leave out the duration and the counting method.  The defaults are UILabelCountingMethodEaseInOut for the mode and 2.0 seconds for the duration.

## Modes #####
There are currently four modes of counting.

### UILabelCountingMethodLinear #####
Counts linearly from the start to the end.  

### UILabelCountingMethodEaseIn #####
Ease On starts out slow and speeds up counting as it gets to the end, stopping suddenly at the final value.

### UILabelCountingMethodEaseOut #####
Ease Out starts out fast and slows down as it gets to the destination value.  

### UILabelCountingMethodEaseInOut #####
Ease In/Out starts out slow, speeds up towards the middle, and then slows down as it approaches the destination.  It is a nice, smooth curve that looks great, and is the default method.
