//
//  MemeTextFieldDelegate.swift
//  Meme Me
//
//  Copyright © 2019 tribl. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    // Clear the text when the user begins editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear the text only if it is placeholder text so the user can edit their entry
        if (textField.text?.elementsEqual("TOP TEXT") ?? false || textField.text?.elementsEqual("BOTTOM TEXT") ?? false) {
            textField.text = ""
        }
    }
    
    // Dismiss the keyboard in "return" press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
