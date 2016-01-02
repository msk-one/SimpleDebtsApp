//
//  DebtTableViewController.swift
//  SimpleDebtsApp
//
//  Created by Msk Sk on 30/12/15.
//  Copyright © 2015 Msk. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class DebtTableViewController: UITableViewController {

    @IBOutlet weak var debtNameTextView: UITextView!
    @IBOutlet weak var debtWhoTextField: UITextField!
    @IBOutlet weak var debtAmountTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let debtListName = "debtList.plist"
    var debtDictionary:NSMutableDictionary!
    var debtList = [Dictionary<String, String>]()
    
    var debtToDisplay = Dictionary<String, String>()
    var debtIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if debtDictionary != nil {
            debtList = debtDictionary["debts"] as! [Dictionary<String,String>]
            
            if debtToDisplay["debt"] != nil {
                debtNameTextView.text = debtToDisplay["debt"]
                debtWhoTextField.text = debtToDisplay["who"]
            }
            else {
                
            }
        }

        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 3 {
            if debtToDisplay["debt"] == nil {
                return 0
            }
            else {
                return 40
            }
        }
        else if indexPath.section == 0 {
            return 68
        }
        else if indexPath.section == 1 {
            return 40
        }
        else if indexPath.section == 2 {
            return 40
        }
        else {
            return 40
        }
    }

    func getDebt() -> Dictionary<String, String> {
        var debt = Dictionary<String,String>()
        
        if debtNameTextView.text != "" && debtWhoTextField.text != "" {
            debt = ["debt":debtNameTextView.text, "who":debtWhoTextField.text!]
        }
        
        return debt
    }
    
    @IBAction func saveDebt(sender: AnyObject) {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let basepath = path[0] + "/"
        let debtListPath = basepath.stringByAppendingString(debtListName)
        
        if debtDictionary == nil {
            debtDictionary = NSMutableDictionary()
        }
        
        if debtToDisplay["debt"] != nil {
            debtList[debtIndex] = getDebt()
        }
        else {
            debtList.append(getDebt())
            debtIndex = debtList.count - 1
        }
        
        debtDictionary["debts"] = debtList
        debtDictionary.writeToFile(debtListPath, atomically: true)
        addToSpotlight(getDebt())
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deleteDebt(sender: AnyObject) {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let basepath = path[0] + "/"
        let debtListPath = basepath.stringByAppendingString(debtListName)
        
        debtList.removeAtIndex(debtIndex)
        removeFromSpotlight(debtIndex)
        debtDictionary["debts"] = debtList
        debtDictionary.writeToFile(debtListPath, atomically: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func removeFromSpotlight(toremove: Int) {
        CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers(["\(toremove)"]) { (error: NSError?) -> Void in
            if error != nil {
                print("Deindexing error: \(error?.localizedDescription)")
            }
        }
    }
    
    func addToSpotlight(debt: Dictionary<String, String>) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = debt["debt"]
        attributeSet.contentDescription = debt["who"]
        
        let searchItem = CSSearchableItem(uniqueIdentifier: "\(debtIndex)", domainIdentifier: "msk.com.SimpleDebtsApp", attributeSet: attributeSet)
        
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([searchItem]) { (error:NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
