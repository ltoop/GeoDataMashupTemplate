//
//  FirstViewController.swift
//  GeoDataMashupTemplate
//
//  Created by Luke Toop on 19/10/2014.
//  Copyright (c) 2014 luketoop.com. All rights reserved.
//

import UIKit
import MapKit

// TODO: Add table header with segmented control to choose sort types
enum SortType {
    case SortByName
    case SortByMagnitude
}

// TODO: Extract table data source into seperate file: will be easier to reuse across other ViewControllers.

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    // The Spinner view is to let the user know you are loading etc
    // TODO: switch to ContainerView
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerMessageLabel: UILabel!
    
    // MARK: variables
    var model: Model
    var sortType = SortType.SortByName
    var tableData: [GenericPointLocation]?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        // You might want your data model as a singleton, but I really hate that pattern
        // This could be owned by the AppDelegate, or you might want to have a model for each view controller tab
        // It's here for now to get to v1 faster.
        // FIXME: Model ownership to move to AppDelegate
        
        self.model = Model()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.model = Model()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinnerView.hidden = false
        self.spinnerMessageLabel.text = "Loading Data..."
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        model.reloadData()
        NSNotificationCenter.defaultCenter()
            .addObserverForName( "DataModelDidChange", object: nil, queue: NSOperationQueue.mainQueue()) { _ in
                self.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - core of the controller lifecycle
    // I highly recommend a functional-style reloadData function that you can call whenever something important happens
    //  and which will sort out the state of the controller and views
    
    func reloadData() {
        switch (self.model.state){
        case .ModelStateInitialised:
            self.spinnerView.hidden = true
        case .ModelStateError(let err):
            let alertView = UIAlertController(title: "Error!", message: err.error.description, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            // TODO: Test error states with CharlesProxy
            return
        case .ModelStateLoading:
            self.spinnerView.hidden = false
            self.spinnerMessageLabel.text = "Still loading..."
            return
        case .ModelStateUninitialised:
            self.spinnerView.hidden = false
            self.spinnerMessageLabel.text = "Data model not ready!"
            return
        }
        self.sortAndFilterItems()
        self.tableView.reloadData()
        self.mapView.addAnnotations(model.listOfAnnotations())
    }
    
    func sortAndFilterItems() {
        self.tableData = model.listOfPointLocations
        switch (sortType) {
        case .SortByName:
            self.tableData?.sort {$0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending}
        case .SortByMagnitude:
            self.tableData?.sort {$0.value > $1.value}
        }
    }
    
    // MARK: - UITableViewDataSource / Delegate functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let td = self.tableData {
            return td.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: Custom cells instead of the generics :P
        let item = self.tableData![indexPath.row]
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel.text = item.name
        // TODO: Customise cell layout
        // cell.detailTextLabel!.text = "Magnitude: \(item.value)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Move map view to the selected location
        let objOfInterest = self.tableData![indexPath.row]
        var coordSpan = MKCoordinateSpanMake(1.0, 1.0)

        // Beware: American spelling of centre causes many typos.
        var coordCenter = CLLocationCoordinate2DMake(objOfInterest.latitude, objOfInterest.longitude)
        self.mapView.setRegion(MKCoordinateRegionMake(coordCenter, coordSpan), animated: true)
    }
}

