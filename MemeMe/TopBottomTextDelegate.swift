//
//  TopBottomTextDelegate.swift
//  MemeMe
//
//  Created by Shubham Tripathi on 01/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//
import Foundation
import UIKit

class TopBottomTextDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}