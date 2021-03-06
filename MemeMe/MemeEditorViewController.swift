//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Shubham Tripathi on 26/07/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var cameraImagePicker: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var topBottomTextDelegate = TopBottomTextDelegate()
    
    // Enum to declare all of the available source types
    enum source: String {
        case Album = "album"
        case Camera = "camera"
    }
    
    // Dictionary containing Meme text attributes
    let memeTextAttributes = [NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        
        topText.delegate = topBottomTextDelegate
        bottomText.delegate = topBottomTextDelegate
        
        // Default state of Share button will be disabled
        shareButton.enabled = false
        
        // Default text for top an bottom textfields
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Checking for availability of Camera
        cameraImagePicker.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotification()
    }
    
    @IBAction func pickImageCamera() {
        imagePicker(source.Camera)
    }
    
    @IBAction func pickImageAlbum() {
        imagePicker(source.Album)
    }
    
    func imagePicker(sourceType: source) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        switch(sourceType) {
            case .Album: imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            case .Camera: imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
        shareButton.enabled = true
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage.image = imagePicked
            originalImage.contentMode = UIViewContentMode.ScaleAspectFit
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = 0
        }   
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
    func generateMemedImage() -> UIImage! {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setToolbarHidden(true, animated: true)
        
        if let mImage = generateMemedImage() {
            
            let controller = UIActivityViewController(activityItems: [mImage], applicationActivities: nil)
            
            controller.completionWithItemsHandler = {
                (activity, success, items, error) in                
                println("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
                
                self.save()
                controller.dismissViewControllerAnimated(true, completion: nil)
                self.sentMeme()
            }
            
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.setToolbarHidden(false, animated: true)
            
            presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    // Re-direct user to SentMemeTabBarViewController
    func sentMeme() {
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemeTabBarViewController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func save() {
        
        // Create the meme
        var meme = Meme(topText: topText.text, bottomText: bottomText.text, originalImage: originalImage.image, memeImage: generateMemedImage())
        
        // Add the generated Meme to the AppDelegate's meme array
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
}

