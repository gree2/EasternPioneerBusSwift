//
//  Parser.swift
//  EasternPioneerBusSwift
//
//  Created by hqlgree2 on 14/3/15.
//  Copyright (c) 2015 hqlgree2. All rights reserved.
//

import Realm

class Parser{
    
    var theHtml = ""
    var body: HTMLNode?
    var success = false
    var busstops = Array<BusStop>()
    
    init(html: String)
    {
        theHtml = html
    }
    
    func parse(){
        
        // get the default Realm
        let realm = RLMRealm.defaultRealm()
        //println(realm.path)
        var config = Config()
        var err : NSError?
        var parser = HTMLDocument(data: theHtml.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), error: &err)
        if err != nil {
            config.key = "sync"
            config.value = "false"
            realm.beginWriteTransaction()
            realm.addObject(config)
            realm.commitWriteTransaction()
            return
        }
        
        body = parser?.body
        

        
        // get bus stop info
        if let tables = body?.nodesForXPath("//*//div[@class='sjz_ejmsgbox']//div//table"){
            
            var busStopCount = 1
            // busline
            for table in tables {
                
                let buslineId = table.attributeForName("id")!
                    .stringByReplacingOccurrencesOfString("line", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                //println(buslineId)
                var busStopIndex = 0
                // table/tbody/tr
                let trs = table.children[0].children
                
                for tr in trs{
                    
                    // jump over table header
                    if 0 == busStopIndex{
                        busStopIndex += 1
                        continue
                    }
                    
                    var tds = tr.children
                    // these are busstops
                    let busstop = BusStop()
                    // busstop id
                    busstop.id = busStopCount
                    busStopCount += 1
                    busstop.busLineId = buslineId.toInt()!
                    busstop.stopName = tds[0].textContent!
                    busstop.stopDesc = tds[1].textContent!
                    // sort busstop
                    busstop.stopIndex = busStopIndex
                    busStopIndex += 1
                    busstop.class07 = tds[2].textContent!
                    busstop.class09 = tds[3].textContent!
                    busstop.class13 = tds[4].textContent!
                    busstop.class17 = tds[5].textContent!
                    // td/em/a
                    if 1 == tds[8].children.count && 1 == tds[8].children[0].children.count{
                        busstop.stopImage = tds[8].children[0].children[0].attributeForName("href")!
                    }
                    //println(busstop.description)
                    busstops.append(busstop)
                    //realm.beginWriteTransaction()
                    //realm.addObject(busstop)
                    //realm.commitWriteTransaction()
                } // end inner for
            } // end outer for
        } // end if
        
        // get busline info
        if let links = body?.nodesForXPath("//*//div[@class='guide_ser']//a"){
            var lineIndex = 1
            for link in links {
                // <a  onclick='ShowLine(1)'>两广线</a>
                if let onclick = link.attributes!["onclick"]{
                    //println(onclick)
                    let id = onclick
                        .stringByReplacingOccurrencesOfString("ShowLine(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        .stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    let busline = BusLine()
                    busline.id = id.toInt()!
                    busline.lineIndex = lineIndex
                    lineIndex += 1
                    busline.lineCode = id
                    busline.lineName = link.textContent!
                    // bind busstop to busline
                    for busstop in busstops{
                        if busstop.busLineId == busline.id{
                            busline.busStops.addObject(busstop)
                        }
                    }
                    //println(busline.description)
                    realm.beginWriteTransaction()
                    realm.addObject(busline)
                    realm.commitWriteTransaction()
                } // end if
            } // end for
            config.key = "sync"
            config.value = "true"
            realm.beginWriteTransaction()
            realm.addObject(config)
            realm.commitWriteTransaction()
        } // end if
    }
}