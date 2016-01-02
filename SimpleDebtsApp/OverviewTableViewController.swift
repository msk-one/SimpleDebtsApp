//
//  OverviewTableViewController.swift
//  SimpleDebtsApp
//
//  Created by Msk Sk on 30/12/15.
//  Copyright © 2015 Msk. All rights reserved.
//

import UIKit

class OverviewTableViewController: UITableViewController {
    
    var debtDictionary:NSMutableDictionary!
    var debts = [Dictionary<String,String>]()
    let debtListName = "debtList.plist"
    var searchDebtIndex:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 104/255, green: 0, blue: 214/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //self.loadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displaySearchResult:", name: "displaySearchResult", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    func displaySearchResult(notification: NSNotification) {
        searchDebtIndex = (notification.object as! NSString).integerValue
        self.performSegueWithIdentifier("editDebt", sender: self)
    }
    
    func loadData() {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let basepath = path[0] + "/"
        let debtListPath = basepath.stringByAppendingString(debtListName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(debtListPath) {
            debtDictionary = NSMutableDictionary(contentsOfFile: debtListPath)
            debts = debtDictionary["debts"] as! [Dictionary<String, String>]
            
            self.tableView.reloadData()
        }
    }

    @IBAction func onRefresh(sender: AnyObject) {
        self.loadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return debts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let debt = debts[indexPath.row]
        
        cell.textLabel?.text = debt["debt"]
        cell.detailTextLabel?.text = debt["who"]

        return cell
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let debtVC = segue.destinationViewController as! DebtTableViewController
        
        if segue.identifier == "createDebt" {
            if debtDictionary != nil {
                debtVC.debtDictionary = debtDictionary
            }
        }
        else if segue.identifier == "editDebt" {
            debtVC.debtDictionary = debtDictionary
            
            let 💾 = self.tableView.indexPathForSelectedRow
            
            if searchDebtIndex != nil {
                debtVC.debtIndex = searchDebtIndex
                debtVC.debtToDisplay = debts[searchDebtIndex]
            }
            else {
                debtVC.debtToDisplay = debts[💾!.row]
                debtVC.debtIndex = 💾!.row
            }
            
        }
        
        
        
        
        
        
    }

}
