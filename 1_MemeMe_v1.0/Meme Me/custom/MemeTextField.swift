//
//  MemeTextField.swift
//  Meme Me
//
//  Copyright © 2019 tribl. All rights reserved.
//

import UIKit

class MemeTextField: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setTextDetails()
    }
    func setTextDetails() {
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor:  UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
            NSAttributedString.Key.strokeWidth: -4.0
        ]
        
        self.defaultTextAttributes = textAttributes
        self.textAlignment = .center
    }
}
