//
//  ProfileViewController.swift
//  ExchangeAGram
//
//  Created by Michael Renninger on 12/15/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "publish_actions"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapViewButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("showMapView", sender: nil)
    }
}

extension ProfileViewController: FBLoginViewDelegate {
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        profileImageView.hidden = false
        nameLabel.hidden = false
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println(user)
        
        nameLabel.text = user.name
        
        /*
        let userImageURL = "https://graph.facebook.com/\(user.objectID)/picture?type=small"
//        let url = NSURL(string: userImageURL)
//        let imageData = NSData(contentsOfURL: url!)
//        let image = UIImage(data: imageData!)
//        profileImageView.image = image
        profileImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: userImageURL)!)!)
        */
        
        profileImageView.image = createUIImageFromURL("https://graph.facebook.com/\(user.objectID)/picture?type=small")
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        profileImageView.hidden = true
        nameLabel.hidden = true
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("Error: \(error.localizedDescription)")
    }
    
    
    
    // Helper 
    func createUIImageFromURL(url:String) -> UIImage {
        return UIImage(data: NSData(contentsOfURL: NSURL(string: url)!)!)!
    }
}
