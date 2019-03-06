import UIKit

enum UILabelCountingMethod: Int{
    case EaseInOut
    case EaseIn
    case EaseOut
    case Linear
};

typealias UICountingLabelFormatBlock = Float -> (String)
typealias UICountingLabelAttributedFormatBlock = Float -> (NSAttributedString)



    
    class UILabelCounterLinear : UILabelCounter
    {
        override func update(t:Float)->Float
        {
            return t;
        }
    }

class UILabelCounterEaseInOut : UILabelCounter
{
    override func update(t:Float)->Float
    {
        var sign:Float = 1.0;
        var r = self.rate;
        if (r % 2 == 0)
        {
            sign = -1.0;
        }
        var t = t;
        t *= 2;
        if (t < 1)
        {
            return 0.5 * powf(t, self.rate);
        }
        else
        {
            return sign * 0.5 * (powf (t-2, self.rate) + sign*2);
        }
        
    }
}

class UILabelCounterEaseIn : UILabelCounter
{
    override func update(t:Float)->Float
    {
        return powf(t, self.rate);
    }
}

class UILabelCounterEaseOut : UILabelCounter
{
    override func update(t:Float)->Float
    {
        return 1.0-powf((1.0-t), self.rate)
    }
}


class UILabelCounter: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        coder = aDecoder;
    }
    
    private var _format:NSString = "%i";
    var format:NSString?
        {
        get{
            return _format
        }
        set{
            _format = newValue != nil ? newValue! : "%i";
            // update label with new format
            self.setTextValue(self.currentValue);
        }
    }
    var method:UILabelCountingMethod = UILabelCountingMethod.EaseIn;
    var animationDuration:NSTimeInterval = 2.0;
    
    var formatBlock:UICountingLabelFormatBlock?;
    var attributedFormatBlock:UICountingLabelAttributedFormatBlock?;
    var completionBlock: (() -> ())!;
    
    var currentValue:Float
        {
        get{
            if (self.progress >= self.totalTime) {
                return self.destinationValue;
            }
            
            var percent = self.progress / self.totalTime;
            var updateVal = self.counter!.update(Float(percent));
            return self.startingValue + (updateVal * (self.destinationValue - self.startingValue));
        }
    };
    
    var rate:Float = 0.0
    
    private var coder: NSCoder?;
    private var startingValue:Float = 0.0;
    private var destinationValue:Float = 0.0;
    private var progress:NSTimeInterval = 0.0;
    private var lastUpdate:NSTimeInterval = 0.0;
    private var totalTime:NSTimeInterval = 0.0;
    private var easingRate:Float = 0.0;

    
    weak private var timer:NSTimer?;
    private var counter:UILabelCounter?;
    
    func update(t:Float)->Float
    {
        return 0;
    }
    
    private func setTextValue(value:Float)
    {
        if (self.attributedFormatBlock != nil) {
            self.attributedText = self.attributedFormatBlock!(value);
    }
    else if(self.formatBlock != nil)
    {
        self.text = self.formatBlock!(value);
    }
    else
    {
    // check if counting with ints - cast to int
        if self.format!.rangeOfString("%(.*)(d|i)", options: .RegularExpressionSearch, range: NSMakeRange(0, self.format!.length)).location != NSNotFound
        {
            self.text = NSString(format:self.format!, Int(value));
        }
        else
        {
            self.text = NSString(format:self.format!, value);
        }
    
    }
    }
    func updateValue(timer:NSTimer) {
        
        // update progress
        var now = NSDate.timeIntervalSinceReferenceDate();
        self.progress += now - self.lastUpdate;
        self.lastUpdate = now;
        
        if (self.progress >= self.totalTime) {
            self.timer?.invalidate();
            self.timer = nil;
            self.progress = self.totalTime;
        }
        
        self.setTextValue(self.currentValue);
        
        if (self.progress == self.totalTime) {
            self.runCompletionBlock()
        }
    }

    private func runCompletionBlock() {
        if (self.completionBlock != nil) {
            self.completionBlock();
            self.completionBlock = nil;
        }
    }
    
    
    private func countFrom(startValue:Float, endValue:Float, duration:NSTimeInterval){
        
        self.startingValue = startValue;
        self.destinationValue = endValue;
        
        // remove any (possible) old timers
        self.timer?.invalidate();
        self.timer = nil;
        
        if (duration == 0.0) {
            // No animation
            self.setTextValue(endValue);
            self.runCompletionBlock();
            return;
        }
        
        self.easingRate = 3.0;
        self.progress = 0;
        self.totalTime = duration;
        self.lastUpdate = NSDate.timeIntervalSinceReferenceDate();
        
        if (self.format == nil)
        {
            self.format = "%f";
        }
        
        
        switch(self.method)
        {
        case UILabelCountingMethod.Linear:
            self.counter = UILabelCounterLinear(coder: self.coder!);
            break;
        case UILabelCountingMethod.EaseIn:
            self.counter = UILabelCounterEaseIn(coder: self.coder!);
            break;
        case UILabelCountingMethod.EaseOut:
            self.counter = UILabelCounterEaseOut(coder: self.coder!);
            break;
        case UILabelCountingMethod.EaseInOut:
            self.counter = UILabelCounterEaseInOut(coder: self.coder!);
            break;
        }
        
        self.counter!.rate = 3.0;
        var timer = NSTimer(timeInterval: (1.0/30.0), target: self, selector: Selector("updateValue:"), userInfo: nil, repeats: true);
        
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: UITrackingRunLoopMode)
        
        self.timer = timer;
    }

    
    private func countFrom(value:Float, endValue:Float) {
    
        if (self.animationDuration == 0.0) {
            self.animationDuration = 2.0;
        }
        self.countFrom(value, endValue: endValue, duration: self.animationDuration)
    }
    
    func countFromCurrentValueTo(endValue:Float) {
        self.countFrom(self.currentValue, endValue: endValue)
    }
    
    func countFromCurrentValueTo(endValue:Float, duration:NSTimeInterval) {
        self.countFrom(self.currentValue, endValue: endValue,duration:duration)
    }
    
    func countFromZeroTo(endValue:Float) {
        self.countFrom(0, endValue: endValue)
    }
    func countFromZeroTo(endValue:Float, duration:NSTimeInterval) {
        self.countFrom(0, endValue: endValue,duration:duration)
    }
}

