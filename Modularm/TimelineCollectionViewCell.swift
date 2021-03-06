//
//  TimelineCollectionViewCell.swift
//  Modularm
//
//  Created by Klein, Greg on 5/17/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

let RevealCellDidOpenNotification = "RevealCellDidOpenNotification"

class TimelineCollectionViewCell: UICollectionViewCell
{
   @IBOutlet private weak var label: UILabel!
   @IBOutlet private weak var innerContentView: UIView!
   @IBOutlet private weak var scrollView: TapScrollView!
   @IBOutlet private weak var activateButton: UIButton!
   @IBOutlet private weak var separatorView: UIView!
   @IBOutlet private weak var activateButtonWidthConstraint: NSLayoutConstraint!
   @IBOutlet private weak var circleImageView: UIImageView!
   @IBOutlet private weak var alarmIconImageView: UIImageView!
   
   weak var collectionView: UICollectionView?
   weak var alarm: Alarm?
   
   private var deleteButton: UIButton = UIButton.timelineCellDeleteButton()
   private var toggleButton: UIButton = UIButton.timelineCellToggleButton()
   private var buttonContainer = UIView()
   private var isOpen: Bool = false
   private var originalActivateButtonWidth: CGFloat = 0.0
   
   override var highlighted: Bool {
      get {
         return super.highlighted
      }
      set {
         if let alarm = self.alarm
         {
            if alarm.active == true
            {
               let whiteValue: CGFloat = newValue ? 0.15 : 0.09
               self.innerContentView.backgroundColor = UIColor(white: whiteValue, alpha: 1)
            }
         }
         super.highlighted = newValue
      }
   }
   
   // MARK: - Lifecycle
   override func awakeFromNib()
   {
      self.deleteButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(self.contentView.bounds))
      self.deleteButton.addTarget(self, action: "deletePressed", forControlEvents: .TouchDown)
      
      self.toggleButton.frame = CGRectMake(CGRectGetWidth(self.deleteButton.frame), 0, 50, CGRectGetHeight(self.contentView.bounds))
      self.toggleButton.addTarget(self, action: "togglePressed", forControlEvents: .TouchDown)
      
      self.setupButtonContainer()
      self.setupScrollViewWithButtonContainer(self.buttonContainer)
      
      self.originalActivateButtonWidth = self.activateButtonWidthConstraint.constant
   }
   
   override func layoutSubviews()
   {
      super.layoutSubviews()
      
      self.contentView.frame = self.bounds;
      self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width + CGRectGetWidth(self.buttonContainer.frame), self.scrollView.frame.size.height);
      
      self.repositionButtons()
   }
   
   // MARK: - Setup
   private func setupScrollViewWithButtonContainer(container: UIView)
   {
      self.scrollView.tapDelegate = self
      self.scrollView.insertSubview(container, belowSubview: self.innerContentView)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOpen:", name: RevealCellDidOpenNotification, object: nil)
   }
   
   private func setupButtonContainer()
   {
      self.buttonContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.toggleButton.frame), CGRectGetHeight(self.contentView.bounds))
      self.buttonContainer.addSubview(self.deleteButton)
      self.buttonContainer.addSubview(self.toggleButton)
   }
   
   private func updateButtonContainerForAlarm(alarm: Alarm?)
   {
      if let alarm = alarm
      {
         if alarm.active
         {
            self.toggleButton.removeFromSuperview()
            self.toggleButton.frame = CGRectMake(CGRectGetWidth(self.deleteButton.frame), 0, 50, CGRectGetHeight(self.contentView.bounds))
            self.buttonContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.toggleButton.frame), CGRectGetHeight(self.contentView.bounds))
            
            self.buttonContainer.addSubview(self.toggleButton)
         }
         else
         {
            self.toggleButton.removeFromSuperview()
            self.buttonContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.deleteButton.frame), CGRectGetHeight(self.contentView.bounds))
         }
      }
   }
   
   // MARK: - Button Actions
   func togglePressed()
   {
      self.scrollView.contentOffset = CGPointZero
      AlarmManager.disableAlarm(self.alarm!)
   }
   
   func deletePressed()
   {
      self.scrollView.contentOffset = CGPointZero
      AlarmManager.deleteAlarm(self.alarm!)
   }
   
   @IBAction func activateButtonPressed()
   {
      AlarmManager.enableAlarm(self.alarm!)
      self.updateButtonContainerForAlarm(self.alarm)
   }
   
   // MARK: - Private
   private func repositionButtons()
   {
      var frame = self.buttonContainer.frame;
      frame.origin.x = self.contentView.frame.size.width - CGRectGetWidth(self.buttonContainer.frame) + self.scrollView.contentOffset.x;
      self.buttonContainer.frame = frame;
   }
   
   private func animateContenteOffset(position: CGPoint, withDuration duration: NSTimeInterval)
   {
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
         UIView.animateWithDuration(duration, animations: { () -> Void in
            self.scrollView.contentOffset = position
         })
      })
   }

   private func animateContenteOffset(position: CGPoint, withDuration duration: NSTimeInterval, completion: ((Bool) -> Void)?)
   {
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
         UIView.animateWithDuration(duration, animations: { () -> Void in
            self.scrollView.contentOffset = position
         }, completion: completion)
      })
   }
   
   private func setActivateButtonHidden(hidden: Bool)
   {
      let width = hidden ? 0 : self.originalActivateButtonWidth
      self.activateButtonWidthConstraint.constant = width
   }
   
   private func setColorsWithViewModel(model: TimelineCellAlarmViewModel)
   {
      self.innerContentView.backgroundColor = model.innerContentViewBackgroundColor
      self.separatorView.backgroundColor = model.separatorViewBackgroundColor
      self.scrollView.backgroundColor = model.scrollViewBackgroundColor
   }
   
   private func setIconsWithViewModel(model: TimelineCellAlarmViewModel)
   {
      self.circleImageView.image = model.circleBackgroundImage
      self.circleImageView.tintColor = model.circleBackgroundImageTintColor
      self.alarmIconImageView.image = model.alarmIconImage
      self.alarmIconImageView.tintColor = model.alarmIconImageTintColor
   }
   
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
      if let alarm = self.alarm
      {
         var viewModel = TimelineCellAlarmViewModel(alarm: alarm)
         
         self.setColorsWithViewModel(viewModel)
         self.setIconsWithViewModel(viewModel)
         self.label.attributedText = viewModel.attributedLabelText
         
         self.setActivateButtonHidden(alarm.active)
         self.updateButtonContainerForAlarm(alarm)
      }
   }
   
   // MARK: - Notification-based Methods
   func onOpen(notification: NSNotification)
   {
      if let object = notification.object as? TimelineCollectionViewCell where object != self && self.isOpen {
         self.animateContenteOffset(CGPoint.zero, withDuration: 0.1)
      }
      else if let _ = notification.object as? TimelineHeaderView where self.isOpen {
         self.animateContenteOffset(CGPoint.zero, withDuration: 0.1)
      }
   }
}

extension TimelineCollectionViewCell: UIScrollViewDelegate
{
   func scrollViewDidScroll(scrollView: UIScrollView)
   {
      self.repositionButtons()
      
      // Don't allow scrolling right
      if scrollView.contentOffset.x < 0 {
         scrollView.contentOffset = CGPointZero;
      }
      
      if scrollView.contentOffset.x >= CGRectGetWidth(self.buttonContainer.frame)
      {
         self.isOpen = true;
         NSNotificationCenter.defaultCenter().postNotificationName(RevealCellDidOpenNotification, object: self)
      }
      else
      {
         self.isOpen = false;
      }
   }
   
   func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
   {
      var contentOffset = CGPointZero
      if velocity.x > 0
      {
         targetContentOffset.memory.x = CGRectGetWidth(self.buttonContainer.frame)
         contentOffset.x = CGRectGetWidth(self.buttonContainer.frame)
      }
      else
      {
         targetContentOffset.memory.x = 0;
      }
      self.animateContenteOffset(contentOffset, withDuration: 0.1)
   }
}

extension TimelineCollectionViewCell: TapScrollViewDelegate
{
   func tapScrollView(scrollView: UIScrollView, touchesBegan touches: NSSet, withEvent event: UIEvent)
   {
      self.highlighted = !self.isOpen
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesCancelled touches: NSSet, withEvent event: UIEvent)
   {
      self.highlighted = false
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesEnded touches: NSSet, withEvent event: UIEvent)
   {
      if let indexPath = self.collectionView?.indexPathForCell(self) where !self.isOpen
      {
         self.highlighted = false
         self.collectionView!.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
         self.collectionView!.delegate?.collectionView!(self.collectionView!, didSelectItemAtIndexPath: indexPath)
         
         NSNotificationCenter.defaultCenter().postNotificationName(RevealCellDidOpenNotification, object: self)
      }
      else
      {
         self.animateContenteOffset(CGPointZero, withDuration: 0.1, completion: { (finished: Bool) -> Void in
            self.isOpen = false
         })
      }
   }
}
