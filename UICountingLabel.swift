//
//  UICountingLabel.swift
//  CountingTestProject
//
//  Created by Antoine Cœur on 2019/3/6.
//  Copyright © 2019 Tim Gostony. All rights reserved.
//

import UIKit
import QuartzCore

@objc enum UILabelCountingMethod: NSInteger {
    case easeInOut
    case easeIn
    case easeOut
    case linear
    case easeInBounce
    case easeOutBounce
    
    fileprivate var counter: (_ t: CGFloat) -> CGFloat {
        switch self {
        case .linear:
            return UILabelCounterLinear.update
        case .easeIn:
            return UILabelCounterEaseIn.update
        case .easeOut:
            return UILabelCounterEaseOut.update
        case .easeInOut:
            return UILabelCounterEaseInOut.update
        case .easeOutBounce:
            return UILabelCounterEaseOutBounce.update
        case .easeInBounce:
            return UILabelCounterEaseInBounce.update
        }
    }
}

typealias UICountingLabelFormatBlock = (_ value: CGFloat) -> String
typealias UICountingLabelAttributedFormatBlock = (_ value: CGFloat) -> NSAttributedString

#if !swift(>=4.2)
private extension RunLoopMode {
    static let `default` = RunLoopMode.defaultRunLoopMode
    static let tracking = RunLoopMode.UITrackingRunLoopMode
}
#endif

// MARK: - UILabelCounter

public var kUILabelCounterRate: CGFloat = 3.0

private protocol UILabelCounter {

    static func update(_ t: CGFloat) -> CGFloat

}

private struct UILabelCounterLinear: UILabelCounter {

    static func update(_ t: CGFloat) -> CGFloat {
        return t
    }
}

private struct UILabelCounterEaseIn: UILabelCounter {

    static func update(_ t: CGFloat) -> CGFloat {
        return pow(t, kUILabelCounterRate)
    }
}

private struct UILabelCounterEaseOut: UILabelCounter {

    static func update(_ t: CGFloat) -> CGFloat {
        return 1.0 - pow((1.0 - t), kUILabelCounterRate)
    }
}

private struct UILabelCounterEaseInOut: UILabelCounter {
    
    static func update(_ t: CGFloat) -> CGFloat {
        let t = t * 2
        if t < 1 {
            return 0.5 * pow(t, kUILabelCounterRate)
        } else {
            return 0.5 * (2.0 - pow(2.0 - t, kUILabelCounterRate))
        }
    }
}

private struct UILabelCounterEaseInBounce: UILabelCounter {

    static func update(_ t: CGFloat) -> CGFloat {
        if t < 4.0 / 11.0 {
            return 1.0 - (pow(11.0 / 4.0, 2) * pow(t, 2)) - t
        }
        if t < 8.0 / 11.0 {
            return 1.0 - (3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2)) - t
        }
        if t < 10.0 / 11.0 {
            return 1.0 - (15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2)) - t
        }
        return 1.0 - (63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2)) - t
    }
}

private struct UILabelCounterEaseOutBounce: UILabelCounter {
    
    static func update(_ t: CGFloat) -> CGFloat {
        if t < 4.0 / 11.0 {
            return pow(11.0 / 4.0, 2) * pow(t, 2)
        }
        if t < 8.0 / 11.0 {
            return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2)
        }
        if t < 10.0 / 11.0 {
            return 15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2)
        }
        return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2)
    }
}

// MARK: - UICountingLabel

public class UICountingLabel: UILabel {
    
    @objc var format: String = "%f"
    @objc var method: UILabelCountingMethod = .easeInOut
    @objc var animationDuration: TimeInterval = 2.0
    
    @objc var formatBlock: UICountingLabelFormatBlock?
    @objc var attributedFormatBlock: UICountingLabelAttributedFormatBlock?
    @objc var completionBlock: (() -> Void)?
    
    @objc func count(from startValue: CGFloat, to endValue: CGFloat) {
        if self.animationDuration == 0 {
            self.animationDuration = 2.0
        }
        self.count(from: startValue, to: endValue, withDuration: self.animationDuration)
    }
    @objc func count(from startValue: CGFloat, to endValue: CGFloat, withDuration duration: TimeInterval) {
        self.startingValue = startValue
        self.destinationValue = endValue
        
        // remove any (possible) old timers
        self.timer?.invalidate()
        self.timer = nil
        
        if duration == 0 {
            // No animation
            self.setTextValue(endValue)
            self.runCompletionBlock()
            return
        }
        
        self.easingRate = 3.0
        self.progress = 0
        self.totalTime = duration
        self.lastUpdate = NSDate.timeIntervalSinceReferenceDate
        
        self.counter = self.method.counter
        
        let timer = CADisplayLink(target: self, selector: #selector(updateValue))
        timer.frameInterval = 2
        timer.add(to: .main, forMode: .default)
        timer.add(to: .main, forMode: .tracking)
        self.timer = timer
    }
    
    @objc func countFromCurrentValue(to endValue: CGFloat) {
        self.count(from: self.currentValue(), to: endValue)
    }
    @objc func countFromCurrentValue(to endValue: CGFloat, withDuration duration: TimeInterval) {
        self.count(from: self.currentValue(), to: endValue, withDuration: duration)
    }
    
    @objc func countFromZero(to endValue: CGFloat) {
        self.count(from: 0, to: endValue)
    }
    @objc func countFromZero(to endValue: CGFloat, withDuration duration: TimeInterval) {
        self.count(from: 0, to: endValue, withDuration: duration)
    }
    
    @objc func currentValue() -> CGFloat {
        if self.progress >= self.totalTime {
            return self.destinationValue
        }
        let percent = self.progress / self.totalTime
        let updateVal = self.counter(CGFloat(percent))
        return self.startingValue + (updateVal * (self.destinationValue - self.startingValue))
    }
    
    private var startingValue: CGFloat = 0
    private var destinationValue: CGFloat = 0
    private var progress: TimeInterval = 0
    private var lastUpdate: TimeInterval = 0
    private var totalTime: TimeInterval = 0
    private var easingRate: CGFloat = 0
    
    private var timer: CADisplayLink?
    private var counter: (_ t: CGFloat) -> CGFloat = UILabelCounterEaseInOut.update
    
    @objc private func updateValue(timer: Timer) {
        // update progress
        let now = NSDate.timeIntervalSinceReferenceDate
        self.progress += now - self.lastUpdate
        self.lastUpdate = now
        
        if self.progress >= self.totalTime {
            self.timer?.invalidate()
            self.timer = nil
            self.progress = self.totalTime
        }
        
        self.setTextValue(self.currentValue())
        
        if self.progress == self.totalTime {
            self.runCompletionBlock()
        }
    }
    
    private func setTextValue(_ value: CGFloat) {
        if self.attributedFormatBlock != nil {
            self.attributedText = self.attributedFormatBlock?(value)
        } else if self.formatBlock != nil {
            self.text = self.formatBlock?(value)
        } else {
            // check if counting with ints - cast to int
            // regex based on IEEE printf specification: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
            if self.format.range(of: "%[^fega]*[diouxc]", options: [.regularExpression, .caseInsensitive])?.isEmpty == false {
                self.text = String(format: self.format, Int(value))
            } else {
                self.text = String(format: self.format, value)
            }
        }
    }
    
    private func setFormat(_ format: String) {
        self.format = format
        // update label with new format
        self.setTextValue(self.currentValue())
    }
    
    private func runCompletionBlock() {
        
        self.completionBlock?()
        self.completionBlock = nil
    }
}
