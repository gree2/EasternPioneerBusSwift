//
//  BusStop.swift
//  EasternPioneerBusSwift
//
//  Created by hqlgree2 on 14/3/15.
//  Copyright (c) 2015 hqlgree2. All rights reserved.
//

import Realm

class BusStop: RLMObject {
    dynamic var id = 0
    dynamic var busLineId = 0
    dynamic var stopIndex = 0
    dynamic var stopName = ""
    dynamic var stopDesc = ""
    dynamic var class07 = ""
    dynamic var class09 = ""
    dynamic var class13 = ""
    dynamic var class17 = ""
    dynamic var distance = ""
    dynamic var distanceEta = ""
    dynamic var stopImage = ""
}