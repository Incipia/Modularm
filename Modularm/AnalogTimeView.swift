//
//  AnalogTimeView.swift
//  Modularm
//
//  Created by Gregory Klein on 10/8/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AnalogTimeView: TimeView
{
   private var _currentColor = UIColor.whiteColor()
   private let clockView: BEMAnalogClockView

   // MARK: - Init
   required init?(coder aDecoder: NSCoder)
   {
      clockView = BEMAnalogClockView(frame: CGRect.zero)
      super.init(coder: aDecoder)
      _commonInit()
   }
   
   override init(frame: CGRect)
   {
      clockView = BEMAnalogClockView(frame: frame)
      super.init(frame: frame)
      _commonInit()
   }
   
   private func _commonInit()
   {
      setupClockView()
      addSubview(clockView)
      _visualEffectView.layer.masksToBounds = true
   }
   
   // MARK: - Setup
   private func setupClockView()
   {
      clockView.borderWidth = 0;
      clockView.faceBackgroundAlpha = 0.0;
      if let font = UIFont(name: "HelveticaNeue-Thin", size: 14) {
         clockView.digitFont = font
      }
      clockView.digitColor = UIColor.whiteColor()
      clockView.digitOffset = 0
      clockView.enableDigit = true
      clockView.secondHandColor = UIColor.lipstickRedColor()
      clockView.hubRadius = 10
      clockView.hubColor = UIColor.whiteColor()
      clockView.enableHub = true
      clockView.minuteHandLength = 92
      clockView.hourHandLength = 65
      clockView.hourHandWidth = 5
      clockView.hourHandOffsideLength = 0
      clockView.secondHandOffsideLength = -10
      clockView.secondHandLength = 107
      clockView.delegate = self
   }
   
   // MARK: - Lifecycle
   override func layoutSubviews()
   {
      clockView.frame = bounds
      _visualEffectView.layer.cornerRadius = bounds.width * 0.5
      super.layoutSubviews()
   }
   
   // MARK: - Overridden
   override func updateTimeWithAlarm(alarm: Alarm)
   {
      super.updateTimeWithAlarm(alarm)
      updateClock()
   }
   
   override func updateTimeWithHour(hour: Int, minute: Int)
   {
      super.updateTimeWithHour(hour, minute: minute)
      updateClock()
   }
   
   private func updateClock()
   {
      clockView.hours = self.time.hour
      clockView.minutes = self.time.minute
      clockView.updateTimeWithAnimationDuration(0.4)
   }
   
   override func updateColor(color: UIColor)
   {
      clockView.digitColor = color
      clockView.hubColor = color
      clockView.hourHandColor = color
      clockView.minuteHandColor = color
      _currentColor = color
      
      clockView.setNeedsDisplay()
   }
}

extension AnalogTimeView: BEMAnalogClockDelegate
{
   func analogClock(clock: BEMAnalogClockView!, graduationColorForIndex index: Int) -> UIColor!
   {
      return _currentColor
   }
   
   func analogClock(clock: BEMAnalogClockView!, graduationLengthForIndex index: Int) -> CGFloat
   {
      return index % 5 == 0 ? -1.0 : 5.0
   }
}
