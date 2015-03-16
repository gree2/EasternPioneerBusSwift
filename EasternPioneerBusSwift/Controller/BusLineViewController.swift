//
//  BusLineViewController.swift
//  EasternPioneerBusSwift
//
//  Created by hqlgree2 on 14/3/15.
//  Copyright (c) 2015 hqlgree2. All rights reserved.
//

import UIKit

@objc
protocol BusLineDelegate{
    func busLineSelected(busLine: BusLine)
}

class BusLineViewController: UITableViewController,
    UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableview: UITableView!
    
    var delegate: BusLineDelegate?
    
    let busLines = BusLine.allObjects()
        .sortedResultsUsingProperty("lineIndex", ascending: true)
    
    struct TableView {
        struct CellIdentifiers{
            static let BusLineCell = "BusLineCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Int(busLines.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.BusLineCell, forIndexPath: indexPath) as BusLineCell
        // Configure the cell...
        cell.configure(busLines[UInt(indexPath.row)] as BusLine)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let busLine = busLines[UInt(indexPath.row)] as BusLine
        delegate?.busLineSelected(busLine)
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("BusLineViewController")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("BusLineViewController")
    }
    
}

class BusLineCell: UITableViewCell {
    
    @IBOutlet weak var lineNameLabel: UILabel!
    
    
    func configure(busLine: BusLine){
        lineNameLabel.text = String(busLine.lineIndex) + " " + busLine.lineName
    }
}
