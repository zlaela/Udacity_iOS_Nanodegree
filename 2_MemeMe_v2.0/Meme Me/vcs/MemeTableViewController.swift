//
//  MemeTableViewController.swift
//  Meme Me
//
//  Copyright © 2019 tribl. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController : UITableViewController  {
    @IBOutlet var memesTableView: UITableView!
    
    // MARK: Properties
    // Get the Memes array from the App Delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate  = object as! AppDelegate
        return appDelegate.memes
    }
    
    // Reload the data here so we always get the most updated count of memes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the height of each row to 1/6 the hieght of the window
        let dimension = (view.frame.size.height  / 6)
        memesTableView.rowHeight = dimension
    }
    
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // set the image and meme text name
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText) \n \(meme.bottomText)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate a detail view controller
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Get the meme at the present index
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
    
        // Navigate to the selected meme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
