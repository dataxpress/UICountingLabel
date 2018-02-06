# UICountingLabel ####

Adds animated counting support to `UILabel`.

![alt text](https://github.com/dataxpress/UICountingLabel/blob/master/demo.gif "demo")

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

You can also add it to your XIB file, just make sure you set the class type to `UICountingLabel` instead of `UILabel` and be sure to `#import "UICountingLabel.h"` in the header file.

## Use #####

Set the format of your label.  This will be filled with a single int or float (depending on how you format it) when it updates:

    myLabel.format = @"%d";

Alternatively, you can provide a `UICountingLabelFormatBlock`, which permits greater control over how the text is formatted:

    myLabel.formatBlock = ^NSString* (CGFloat value) {    
        NSInteger years = value / 12;
        NSInteger months = (NSInteger)value % 12;
        if (years == 0) {
            return [NSString stringWithFormat: @"%ld months", (long)months];
        }
        else {
            return [NSString stringWithFormat: @"%ld years, %ld months", (long)years, (long)months];
        }
    };

There is also a `UICountingLabelAttributedFormatBlock` to use an attributed string. If the `formatBlock` is specified, it takes precedence over the `format`.

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

Optionally, you can specify a `completionBlock` to perform an acton when the label has finished counting:

    myLabel.completionBlock = ^{
        NSLog(@"finished counting");
    };

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

----
# 以下是中文教程
-----
为 `UILabel` 添加计数动画支持.

![alt text](https://github.com/dataxpress/UICountingLabel/blob/master/demo.gif "demo")

## CocoaPods ######
UICountingLabel 可以使用cocoaPods导入,
添加以下代码到你的Podfile文件:

`pod 'UICountingLabel'`

然后运行以下命令:

`$ pod install`

## 设置 ######
初始化 `UICountingLabel` 的方式和普通的 `UILabel`是一样的:

    UICountingLabel* myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    [self.view addSubview:myLabel];

你也可以用在 XIB 文件中, 前提是你在头文件中引入了 `UICountingLabel`的头文件并且使用 `UICountingLabel`替换掉了原生的`UILabel`.

## 使用方式 #####

设置标签格式. 设置标签格式后，标签会在更新数值的时候以你设置的方式填充，默认是显示float类型的数值，也可以设置成显示int类型的数值，比如下面的代码:

    myLabel.format = @"%d";

另外，你也可以使用 `UICountingLabelFormatBlock`, 这个可以对显示的文本格式进行更加高度的自定义:

    // 举例：把显示的月份数变成几年零几个月的样式
    myLabel.formatBlock = ^NSString* (CGFloat value) {    
        NSInteger years = value / 12;
        NSInteger months = (NSInteger)value % 12;
        if (years == 0) {
            return [NSString stringWithFormat: @"%ld months", (long)months];
        }
        else {
            return [NSString stringWithFormat: @"%ld years, %ld months", (long)years, (long)months];
        }
    };

除此之外还有一个 `UICountingLabelAttributedFormatBlock` 用于设置属性字符串的格式,用法和上面的block类似. 如果指定了以上两个 `formatBlock`中的任意一个 , 它将会覆盖掉 `format`属性,因为block的优先级更高.

可选项, 设置动画样式.  默认的动画样式是 `UILabelCountingMethodEaseInOut`, 这个样式是开始时速度比较慢,然后加速,将要结束时减速.  以下将介绍其他动画样式及用法.

    myLabel.method = UILabelCountingMethodLinear; // 线性变化

需要计数时只需要使用以下方法即可:

    [myLabel countFrom:50 to:100];

可以指定动画的时长，默认时长是2.0秒.

    [myLabel countFrom:50 to:100 withDuration:5.0f];

另外也可以使用 `animationDuration` 属性去设置动画时长.

    myLabel.animationDuration = 1.0;

可以使用便利方法计数，例如:

    [myLabel countFromCurrentValueTo:100];
    [myLabel countFromZeroTo:100];

本质上,这些便利方法都是基于一个总方法封装的, 以下就是这个方法完整的声明:

    [myLabel     countFrom:(float)startValue
                        to:(float)endValue
              withDuration:(NSTimeInterval)duration];

可以使用 `-currentValue` 方法获得当前数据, (即使在动画过程中也可以正常获得):

    CGFloat currentValue = [myLabel currentValue];

可以使用 `completionBlock` 获得动画结束的事件:

    myLabel.completionBlock = ^{
        NSLog(@"finished counting");
    };

## 格式 #####

当设置`format`属性后, 标签会检测是否有`%(.*)d`或者`%(.*)i`格式, 如果能找到, 就会将内容以`int`类型展示.  否则, 将会使用默认的`float`类型展示.  

假如你需要以`float`类型展示, 最好设置小数点位数限制, 例如使用`@"%.1f"`来限制只显示一位小数.

因为使用了标准的`stringWithFormat:`方法, 可以按照自己的意愿自定义格式,例如:`@"Points: %i"`.

## 动画类型 #####
当前有四种技术动画样式.

### `UILabelCountingMethodLinear` #####
匀速计数动画.  

### `UILabelCountingMethodEaseIn` #####
开始比较缓慢,快结束时加速,结束时突然停止.

### `UILabelCountingMethodEaseOut` #####
开始速度很快,快结束时变得缓慢.  

### `UILabelCountingMethodEaseInOut` #####
开始时比较缓慢，中间加速，快结束时减速.动画速度是一个平滑的曲线,是默认采用的动画样式。
