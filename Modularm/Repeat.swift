//
//  Repeat.swift
//  Modularm
//
//  Created by Klein, Greg on 5/4/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

enum RepeatDay: Int16
{
   case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
   
   static func valueArray() -> [RepeatDay]
   {
      return [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
   }
   
   var stringValue: String {
      var value = ""
      switch self
      {
      case .Monday:
         value = "Monday"
         break
      case .Tuesday:
         value = "Tuesday"
         break
      case .Wednesday:
         value = "Wednesday"
         break
      case .Thursday:
         value = "Thursday"
         break
      case .Friday:
         value = "Friday"
         break
      case .Saturday:
         value = "Saturday"
         break
      case .Sunday:
         value = "Sunday"
         break
      }
      return value
   }
}

@objc(Repeat)
class Repeat: NSManagedObject
{
    @NSManaged private var monday: Bool
    @NSManaged private var tuesday: Bool
    @NSManaged private var wednesday: Bool
    @NSManaged private var thursday: Bool
    @NSManaged private var friday: Bool
    @NSManaged private var saturday: Bool
    @NSManaged private var sunday: Bool
    @NSManaged private var alarm: Alarm
   
   var atLeastOneDayIsEnabled: Bool {
      get {
         var dayIsEnabeld = false
         for day in RepeatDay.valueArray()
         {
            if self.dayIsEnabled(day) {
               dayIsEnabeld = true
               break
            }
         }
         return dayIsEnabeld
      }
   }
   
   private var enabledDays: [RepeatDay] {
      var enabled = Array<RepeatDay>()
      for day in RepeatDay.valueArray()
      {
         if self.dayIsEnabled(day)
         {
            enabled.append(day)
         }
      }
      return enabled
   }
   
   func enableDay(day: RepeatDay, enabled: Bool)
   {
      switch day
      {
      case .Monday:
         self.monday = enabled
         break
      case .Tuesday:
         self.tuesday = enabled
         break
      case .Wednesday:
         self.wednesday = enabled
         break
      case .Thursday:
         self.thursday = enabled
         break
      case .Friday:
         self.friday = enabled
         break
      case .Saturday:
         self.saturday = enabled
         break
      case .Sunday:
         self.sunday = enabled
         break
      }
   }
   
   func dayIsEnabled(day: RepeatDay) -> Bool
   {
      var enabled = false
      switch day
      {
      case .Monday:
         enabled = self.monday
         break
      case .Tuesday:
         enabled = self.tuesday
         break
      case .Wednesday:
         enabled = self.wednesday
         break
      case .Thursday:
         enabled = self.thursday
         break
      case .Friday:
         enabled = self.friday
         break
      case .Saturday:
         enabled = self.saturday
         break
      case .Sunday:
         enabled = self.sunday
         break
      }
      return enabled
   }
}

extension Repeat: AlarmOptionModelProtocol
{
   func humanReadableString() -> String
   {
      var daysEnabledString = ""
      let enabledDaysArray = enabledDays
      
      for day in enabledDaysArray
      {
         if day == enabledDaysArray.first
         {
            daysEnabledString += day.stringValue
         }
         else if day == enabledDaysArray.last
         {
            daysEnabledString += daysEnabledString.isEmpty ? day.stringValue : " and \(day.stringValue)"
         }
         else
         {
            daysEnabledString += ", \(day)"
         }
      }
      
      return daysEnabledString.isEmpty ? "None" : daysEnabledString
   }
}
