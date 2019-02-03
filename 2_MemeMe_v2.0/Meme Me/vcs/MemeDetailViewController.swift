//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Copyright © 2019 tribl. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    
    // MARK: Properties
    var meme: Meme!
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
