//
//  HelperFunctions.swift
//  GeoDataMashupTemplate
//
//  Created by Luke Toop on 23/10/2014.
//  Copyright (c) 2014 luketoop.com. All rights reserved.
//

import UIKit

class HelperFunctions: NSObject {
    class func stringToDouble(string: String) -> Double {
        var nsStr = NSString(string: string)
        return nsStr.doubleValue
    }
}
