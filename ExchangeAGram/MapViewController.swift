//
//  MapViewController.swift
//  ExchangeAGram
//
//  Created by Michael Renninger on 12/16/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController {
    
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let location = CLLocationCoordinate2D(latitude: 48.868639224587, longitude: 2.37119161036255)
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegionMake(location, span)
//        mapView.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.setCoordinate(location)
//        annotation.title = "Canal Saint-Martin"
//        annotation.subtitle = "Paris"
//        mapView.addAnnotation(annotation)
        
        let req = NSFetchRequest(entityName: "FeedItem")
        let moc = appDelegate.managedObjectContext!
        var error:NSError?
        let itemArray = moc.executeFetchRequest(req, error: &error)
        println(error)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        if itemArray!.count > 0 {
            for item in itemArray! {
                let location = CLLocationCoordinate2D(latitude: Double(item.latitude), longitude: Double(item.longitude))
                let region = MKCoordinateRegionMake(location, span)
                mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.setCoordinate(location)
                annotation.title = item.caption
                mapView.addAnnotation(annotation)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension MapViewController
