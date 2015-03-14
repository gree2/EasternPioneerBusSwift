//
//  BusLine.swift
//  EasternPioneerBusSwift
//
//  Created by hqlgree2 on 14/3/15.
//  Copyright (c) 2015 hqlgree2. All rights reserved.
//

import Realm

class BusLine: RLMObject {
    dynamic var id = 0
    dynamic var lineIndex = 0
    dynamic var lineName:NSString = ""
    dynamic var lineCode:NSString = ""
    
    dynamic var busStops = RLMArray(objectClassName: BusStop.className())
    
}