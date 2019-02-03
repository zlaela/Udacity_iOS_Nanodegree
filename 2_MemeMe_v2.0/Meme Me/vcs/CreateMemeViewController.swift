//
//  ViewController.swift
//  Meme Me
//
//  Copyright © 2019 tribl. All rights reserved.
//

import UIKit

// Make this view controller a delegate of UINavigationController and UITextFieldDelegate
class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Outlets
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    // MARK: Text Field Delegates
    let memeTextDelegate = MemeTextFieldDelegate()
    
    var memedImage: UIImage? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        // Subscribe to keyboard events here so when we come back
        // from selecting/taking an image, the keybard events are observed
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearSubscriptions()
    }
    
    // MARK: visible user actions
    @IBAction func getGalleryImage(_ sender: Any) {
        pickImage(fromCamera: false)
    }
    
    @IBAction func getCameraImage(_ sender: Any) {
        pickImage(fromCamera: true)
    }
    
    @IBAction func share() {
        // Make the meme
        memedImage = makeMeme()
        
        // Create an Activity View Controller
        let controller = UIActivityViewController(
            activityItems: [memedImage!],
            applicationActivities: nil
        )
        
        // Access the VC's completion handler
        controller.completionWithItemsHandler = { (type,completed,items,error) in
            // Access the completion
            if(completed) {
                // Save the image then return
                self.save()
                self.cancelButton.title = "Done"
                return
            } else {
                // Couldn't complete the share - notify?
            }
        }
        
        // Show the VC
        present(
            controller,
            animated: true,
            completion: nil
        )
    }
    
    @IBAction
    func cancel() {
        resetView()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Set up the view
    private func setUp() {
        // Start with a blank slate
        resetView()
        
        // Set the delegates
        self.topText.delegate = memeTextDelegate
        self.bottomText.delegate = memeTextDelegate
        
        // If there is no camera available, disable the camera button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    private func resetView() {
        // Clear the image
        imageView.image = nil
        
        // Set the initial text
        self.topText.text = "TOP TEXT"
        self.bottomText.text = "BOTTOM TEXT"
        
        // Disable the share button
        shareButton.isEnabled = false
        
        // For funsies, set the background of the UIImageView to a random color
        self.imageView.backgroundColor = generateRandomColor()
    }
    
    // MARK: keep the keyboard below the view
    /**
     The point where y = 0 on the frame is the TOP of the screen
     To move the view on TOP of the keyboard, we subtract the height of the keyboard from the top position (like CSS top: -100)
     **/
    @objc func keyboardWillShow(_ notification: Notification) {
        // Only shift the view if we clicked into the bottom text view
        if(bottomText.isFirstResponder) {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Move the view back to its original spot
        view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // ofCGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Start listening for keyboard events
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Stop listening
    private func clearSubscriptions() {
        /**
         Sure, I could specifically unsubscribe from keyboard notifications,
         but might as well do all so when the app is closed, nothing leaks
         **/
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: user image selection here (camera or gallery)
    private func pickImage(fromCamera: Bool) {
        // set UI Image Picker controller
        let pickerController = UIImagePickerController()
        
        // Assign the delegate to be this ViewController
        pickerController.delegate = self
        
        // Set the source type
        pickerController.sourceType = fromCamera ? .camera : .photoLibrary
        
        // Present the controller
        present(pickerController, animated: true, completion: nil)
    }
    
    /** Called when the user cancels the action **/
    private func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // For funsies, set the background of the UIImageView to a random color
        imageView.backgroundColor = generateRandomColor()
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    /** Called when we have picked an image **/
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get the image that was selected
        /**
         These keys retrieve information from the eidting dictionary about what was returned to the delgate object (self)
         https://developer.apple.com/documentation/uikit/uiimagepickercontroller/infokey
         **/
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // Tell the UIImageView to keep the original aspect ratio of the image (default is to stretch fit)
        imageView.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleAspectFill
        
        // Set the UIImageView's image to what was selected
        imageView.image = image
        
        // Dismiss the UIImagePickerController
        picker.dismiss(animated: true, completion: nil)
        
        // Enable the share button if we have an image set
        self.shareButton.isEnabled = (imageView.image != nil)
    }

    // MARK: Save the image
    private func save(){
        // Initialize the Meme struct
        let meme = Meme(topText: self.topText.text ?? "TOP TEXT",
                 bottomText: self.bottomText.text ?? "BOTTOM TEXT",
                 image: self.imageView.image!,
                 memedImage: memedImage!)
        
        // Save the Meme image to the array in the AppDelegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    // MARK: Generate the meme image by taking a screenshot
    /** https://stackoverflow.com/questions/31582222/how-to-take-screenshot-of-a-uiview-in-swift **/
    private func makeMeme() -> UIImage {
        // Make sure the toolbars are hidden so we don't show them in the screenshot
        toggleToolbars()
        
        // set the size of the image to the size entirety of the screen
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        // draw a snapshot of the whole view heirarchy seen on screen into the current context
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        // get the saved snapshot from context and save it to 'meme'
        let meme : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // Remove the graphics context from the top of the stack
        UIGraphicsEndImageContext()
        
        // Restore the toolbars now that we have an image
        toggleToolbars()
        
        return meme
    }
    
    // MARK: helpers
    private func toggleToolbars() {
        self.topBar.isHidden = !topBar.isHidden
        self.bottomBar.isHidden = !bottomBar.isHidden
    }
    
    private func generateRandomColor() -> UIColor {
        // Color requires a CGFloat value between 0 and 1
        let color = UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max),
                            green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                            blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
                            alpha: 1)
        return color
    }
}
