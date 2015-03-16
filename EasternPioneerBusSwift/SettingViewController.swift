//
//  SettingViewController.swift
//  EasternPioneerBusSwift
//
//  Created by hqlgree2 on 14/3/15.
//  Copyright (c) 2015 hqlgree2. All rights reserved.
//

import UIKit
import Realm
import Alamofire

@objc
protocol SettingDelegate{
    func backTapped()
}

class SettingViewController: UITableViewController,
    UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableview: UITableView!
    
    var delegate: SettingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //view.backgroundColor = UIColor.redColor()
    }

    @IBAction func backTapped(sender: AnyObject) {
        delegate?.backTapped()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var row = indexPath.row;
        switch(row){
        case 0:
            syncData()
            //
            //        case 1:
            //        case 2:
            
        default:
            break
        }
    }
    
    //
    func syncData(){
        let realm = RLMRealm.defaultRealm()
        println(realm.path)
        
        if let data: AnyObject = Config.objectsWhere("key = 'sync'").firstObject(){
            let config = data as Config
            if "true" != config.value{
                requestData()
            }
        }
        else{
            requestData()
        }
    }
    
    //
    func requestData(){
        Alamofire.request(.GET, "http://wsyc.dfss.com.cn/home/BCView")
            .responseString{ (_,_, string, _ ) in
                let parser = Parser(html:string!)
                parser.parse()
        }
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
        MobClick.beginLogPageView("DetailViewController")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("DetailViewController")
    }

}
