//
//  BusStopViewController.swift
//  EasternPioneerBusSwift
//
//  Created by hqlgree2 on 14/3/15.
//  Copyright (c) 2015 hqlgree2. All rights reserved.
//

import UIKit
import Realm

@objc
protocol BusStopDelegate{
    optional func toggleBusLine()
    optional func toggleSetting()
    optional func collapseSidePanel()
}

class BusStopViewController: UITableViewController,
    UITableViewDataSource, UITableViewDelegate,
    BusLineDelegate, SettingDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    
    var delegate: BusStopDelegate?
    
    var busStops: RLMResults?
    
    struct TableView {
        struct CellIdentifier {
            static let BusStopCell = "BusStopCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        busStops = BusStop.objectsWhere("busLineId = 1")
            .sortedResultsUsingProperty("stopIndex", ascending: true)
        tableview.reloadData()
    }
    
    @IBAction func busLineTapped(sender: AnyObject) {
        delegate?.toggleBusLine!()
    }
    
    @IBAction func settingTapped(sender: AnyObject) {
        delegate?.toggleSetting!()
    }
    
    func busLineSelected(busLine: BusLine) {
        // set title
        title = String(busLine.lineIndex) + " " + busLine.lineName
        println(title!)
        busStops = BusStop.objectsWhere("busLineId = \(busLine.id)")
            .sortedResultsUsingProperty("stopIndex", ascending: true)
        tableview.reloadData()
        delegate?.toggleBusLine!()
    }
    
    func backTapped() {
        delegate?.toggleSetting!()
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
        return Int(busStops!.count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifier.BusStopCell, forIndexPath: indexPath) as BusStopCell
        // Configure the cell...
        cell.configure(busStops?[UInt(indexPath.row)] as BusStop)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let busStop = busStops?[UInt(indexPath.row)] as? BusStop{
            performSegueWithIdentifier("segue_stop_detail", sender: busStop)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier{
            switch identifier{
                case "segue_setting":
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Bordered, target: nil, action: "")
                case "segue_stop_detail":
                    let busStop = sender as? BusStop
                    let backTitle = String(busStop!.stopIndex) + " " + busStop!.stopName
                    println(backTitle)
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: backTitle, style: .Bordered, target: nil, action: "")
                default:break
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("BusStopViewController")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("BusStopViewController")
    }

}

class BusStopCell: UITableViewCell {
    
    @IBOutlet weak var stopNameLabel: UILabel!
    
    func configure(busStop: BusStop){
        stopNameLabel.text = String(busStop.stopIndex) + " " + busStop.stopName
    }
    
}
