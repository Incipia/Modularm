//
//  SettingsViewController.swift
//  Modularm
//
//  Created by Gregory Klein on 10/7/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate
{
   func settingsWillClose()
}

class SettingsViewController: UIViewController
{
   private var _settingsDelegate: SettingsViewControllerDelegate?
   private var tableViewDataSource: SettingsTableViewDataSource?
   @IBOutlet weak var navigationBar: UINavigationBar!
   @IBOutlet weak var tableView: UITableView! {
      didSet {
         tableViewDataSource = SettingsTableViewDataSource(tableView: tableView)
      }
   }
   
   // MARK: - Init
   convenience init(delegate: SettingsViewControllerDelegate)
   {
      self.init(nibName: nil, bundle: nil)
      _settingsDelegate = delegate
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationBar.makeTransparent()
   }
   
   override func viewDidAppear(animated: Bool)
   {
      super.viewDidAppear(animated)
      self.tableViewDataSource?.makeUIEvenMoreAmazing()
   }
   
   private func delay(delay: Double, closure: ()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   override func viewWillDisappear(animated: Bool)
   {
      super.viewWillDisappear(animated)
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle
   {
      return .LightContent
   }
   
   // MARK: - IBActions
   @IBAction func doneButtonPressed()
   {
      _settingsDelegate?.settingsWillClose()
      dismiss()
   }
   
   // MARK: - Private
   private func dismiss()
   {
      dismissViewControllerAnimated(true, completion: nil)
   }
}
