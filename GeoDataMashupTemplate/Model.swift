//
//  Model.swift
//  GeoDataMashupTemplate
//
//  Created by Luke Toop on 21/10/2014.
//  Copyright (c) 2014 luketoop.com. All rights reserved.
//

import UIKit
import MapKit

// MARK: Opinionated Rant Regarding State Machines
//
// I am a very big fan of state machines, especially now that Swift enums provide some great language support.
//
//  The 'normal' way is checking a set of properties to see if they are nil or to look for specific values,
//  but as classes grow/change it is easy to break old assumptions. If you are lucky, the app will blow up right away
//  because the subtle bugs can eat a huge amount of your time and energy.
//
//  Your life will be much easier if you decide what states are logically possible and use switch statements.
//  Especially as the project grows: when your model is making multiple API requests and being accessed from
//  a range of view controllers, you won't be staring at some weird race condition.
//
//  Check out https://github.com/ReactKit/SwiftState which is a bit over-the-top for what we are doing here.

enum ModelState {
    case ModelStateUninitialised
    case ModelStateLoading
    case ModelStateError(error: NSError)
    case ModelStateInitialised
}

let DataModelDidChangeNotification : String! = "dataModelDidChangeNotification"

class Model: NSObject {
    var state : ModelState = .ModelStateUninitialised
    
    var listOfPointLocations: [GenericPointLocation] = []
    
    // TODO: Add support for regions
    // var listOfRegionLocations [GenericRegionLocations]
    
    func seismiCallback (list: [GenericPointLocation], error: NSError?) -> () {
        // BEWARE! Using self sets up retain cycles
        if (error != nil) {
            self.state = .ModelStateError(error: error!)
        } else {
            self.listOfPointLocations = list
            self.state = .ModelStateInitialised
        }
        
        // _Send out a notification that the model has changed_
        //
        //  I know you're probably at a Hackathon right now, but it is worth structuring your internal
        //  communication correctly, as I have seen this cause rapid escalation towards chaos.
        //
        // Your ViewControllers will know what model operations they want performed, and should
        //  ask the Models to initiate the operation.
        // The models should be completely agnostic about who to inform when they do anything. 
        //
        //  Please use notifications for this!
        //
        // Alternatives and their problems:
        // 1. Using a callback from the requesting viewController: think about when there are
        //  multiple view controllers trying to use a shared model. This can get real ugly
        // 2. KVO sounds fantastic in theory, but can cause some really baffling bugs.
        //  Plus, they are only supported on ObjC types.
        // 3. Swift Property Observers have potential, but have to be explicitly implemented.
        
       (NSNotificationCenter.defaultCenter())
            .postNotification(NSNotification(name: "DataModelDidChange", object: nil))
    }
    
    func reloadData() {
        self.state = .ModelStateLoading
        SeismiDataSource().getData(seismiCallback, year: nil, month: nil)
    }
    
    func listOfAnnotations() -> [MKPointAnnotation] {
        var annotationList: [MKPointAnnotation] = []
        for loc in self.listOfPointLocations {
            var annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(loc.latitude, loc.longitude)
            annotation.title = loc.name + " (\(loc.value))"
            annotationList.append(annotation)
        }
        return annotationList
    }
}
