//
//  RepeatOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class RepeatOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   var repeatModel: Repeat
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      let coreDataStack = CoreDataStack.defaultStack
      self.repeatModel = NSEntityDescription.insertNewObjectForEntityForName("Repeat", inManagedObjectContext: coreDataStack.managedObjectContext!) as! Repeat
      
      super.init(tableView: tableView, delegate: delegate)
      self.option = .Repeat
      self.cellLabelDictionary = [0 : ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]]
   }
   
   private func cellIndexForRepeatDay(day: RepeatDay) -> Int
   {
      return Int(day.rawValue)
   }
   
   private func repeatDayForCellIndex(index: Int) -> RepeatDay?
   {
      return RepeatDay(rawValue: Int16(index))
   }
}

extension RepeatOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      if let day = self.repeatDayForCellIndex(indexPath.row)
      {
         cell.accessoryType = self.repeatModel.dayIsEnabled(day) ? .Checkmark : .None
      }
      return cell
   }
}

extension RepeatOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if let day = self.repeatDayForCellIndex(indexPath.row)
      {
         var shouldEnable = !self.repeatModel.dayIsEnabled(day)
         self.repeatModel.enableDay(day, enabled: shouldEnable)
         
         CoreDataStack.defaultStack.saveContext()
         self.tableView.reloadData()
      }
   }
}
