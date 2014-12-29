//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Michael Renninger on 12/11/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData
import MapKit

class FeedViewController: UIViewController {

    // Constants
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    
    // Variables
    var feedArray: [AnyObject] = []
    var locMgr: CLLocationManager!
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // Initializer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImg = UIImage(named: "AutumnBackground")
        view.backgroundColor = UIColor(patternImage: bgImg!)

        // Do any additional setup after loading the view.
        locMgr = CLLocationManager()
        locMgr.delegate = self
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        locMgr.requestAlwaysAuthorization()
        
        locMgr.distanceFilter = 100.0
        locMgr.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        let req = NSFetchRequest(entityName: "FeedItem")
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        feedArray = context.executeFetchRequest(req, error: nil)!
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // IBActions
    @IBAction func profileTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("profileSegue", sender: nil)
    }
    
    @IBAction func snapBarButtonItemTapped(sender: UIBarButtonItem) {
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) && !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            var alertView = UIAlertController(title: "Alert", message: "Your device doesn't support te camera or photo library", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else {
            var controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.isSourceTypeAvailable(.Camera) ? .Camera : .PhotoLibrary
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            controller.mediaTypes = mediaTypes
            controller.allowsEditing = false
            self.presentViewController(controller, animated:true, completion: nil)
        }
    }
}



// Class Extensions
extension FeedViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("Locations: \(locations)")
    }
}

extension FeedViewController: UINavigationControllerDelegate {
    
}

extension FeedViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let thumbnailData = UIImageJPEGRepresentation(image, 0.1)
        
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
        let feedItem = FeedItem(entity:entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        feedItem.image = imageData
        feedItem.caption = "test caption"
        feedItem.thumbnail = thumbnailData
        feedItem.latitude = locMgr.location.coordinate.latitude
        feedItem.longitude = locMgr.location.coordinate.longitude
        feedItem.uniqueID = NSUUID().UUIDString
        feedItem.filtered = false
            
        appDelegate.saveContext()
        
        feedArray.append(feedItem)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        collectionView.reloadData()
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("CellProto", forIndexPath: indexPath) as FeedCell
        
        let tItem = feedArray[indexPath.row] as FeedItem
        
        var image: UIImage!
        if tItem.filtered == true {
            let returnedImage = UIImage(data: tItem.image)!
            image = UIImage(CGImage: returnedImage.CGImage, scale: 1.0, orientation: .Right)
        }
        else {
            image = UIImage(data: tItem.image)
        }
        
        cell.imageView.image = image
        cell.captionLabel.text = tItem.caption
        
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let tItem = feedArray[indexPath.row] as FeedItem
        
        var filterVC = FilterViewController()
        filterVC.thisFeedItem = tItem
        
        self.navigationController?.pushViewController(filterVC, animated: false)
    }
}
