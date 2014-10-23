//
//  SeismiDataSource.swift
//  GeoDataMashupTemplate
//
//  Created by Luke Toop on 21/10/2014.
//  Copyright (c) 2014 luketoop.com. All rights reserved.
//

import UIKit
import Alamofire

class SeismiDataSource: NSObject {
    let url = NSURL(string:"http://www.seismi.org/api/eqs/")

    func getData(callback: (([GenericPointLocation], NSError?) -> ()), year: Int?, month: Int?) {
        var urlString = "http://www.seismi.org/api/eqs/"
    
        if (year != nil) {
            urlString = urlString + String(year!)
            // Only want to set month if a year was given
            if (month != nil) {
                urlString = urlString + String(month!)
            }
        }

        Alamofire.request(.GET, urlString)
            .responseJSON {(request, response, responseJSON, error) in
                if (error != nil) {
                    // log to console
                    println("Error in JSON request: \(error) ")
                }
                if (responseJSON != nil) {
                    var seismiData = JSON(responseJSON!)
                    let eqList = seismiData["earthquakes"].array?
                    var gplList : [GenericPointLocation] = []
                    for eq in eqList! {
                        var name = eq["region"].string!
                        var latString = eq["lat"].string!
                        var lonString = eq["lon"].string!
                        var valString = eq["magnitude"].string!
                        
                        var eqItem = GenericPointLocation(name: name,
                            latitude: HelperFunctions.stringToDouble(latString),
                            longitude: HelperFunctions.stringToDouble(lonString),
                            value: HelperFunctions.stringToDouble(valString))
                        gplList.append(eqItem)
                    }
                    callback(gplList, error)
                }
        }
        
    }
    //func arrayOfDataPoints() -> [GenericPointLocation] {}
}
