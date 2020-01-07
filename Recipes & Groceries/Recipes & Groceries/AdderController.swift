//
//  AdderController.swift
//  Recipes & Groceries
//
//  Created by Rakan Alshubat on 11/5/18.
//  Copyright © 2018 Rakan Alshubat. All rights reserved.
//

import UIKit
import CoreData

class AdderController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var measurmentField: UITextField!
    @IBOutlet weak var ingredientField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var addIngredient: UIButton!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var addRecipe: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    var gm:groceryModel = groceryModel();
    
    var ingredients = [String]()
    var Rimage:UIImage?
    var Rtitle:String?
    var Rdescription:String?
    var ing:String?
    var cancelStatus:Bool?
    var Totalprice = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize bolean value to see if the user pressed "cancel"
        cancelStatus = false
        
        //make sure the amount field only takes numbers
        amountField.keyboardType = UIKeyboardType.decimalPad
        
        //Since TextView doesnt have a placeholder, i made one. This disappears when clicked on (done somewhere else)
        descriptionField.delegate = self
        descriptionField.text = "Enter your recipe description here!"
        descriptionField.textColor = UIColor.lightGray
    }
    
    
    //This func relates to the "add ingredient" button
    @IBAction func addIngredient(_ sender: Any) {
        
        //make sure again that the user entered a number in the "amount" field
        if let _ = Double(amountField.text!) {
            
            //
            let trimmedString = ingredientField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //combine the three fields into one string
            ing = amountField.text! + "-" + measurmentField.text! + "-" + trimmedString
            
            let _ = gm.getGroceryPrice(ingredient: trimmedString)
           
            //put the string into an array of ingredients
            ingredients.append(ing!)
            
            //clear the fields for a new entry
            amountField.text = ""
            measurmentField.text = ""
            ingredientField.text = ""
            
        //else, display an alert that tells the user to enter a number.
        }else{
            let alert = UIAlertController(title: "Incorrect Entry", message: "Please Enter A Number In The First Ingredients Field (An Amount)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel){ (action) in}
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //This button is to add a photo to the recipe
    @IBAction func addPhoto(_ sender: Any) {
        
        //The alert
        let alert = UIAlertController(title: "Add A Photo", message: "", preferredStyle: .actionSheet)
    
        //If the user pics "photo library" then the library in the phone pops up
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            
            
            self.present(photoPicker, animated: true, completion: nil)
            
        }
        
        //If the user pics "camera" then the camera in the phone pops up
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.sourceType = .camera
                photoPicker.cameraCaptureMode = .photo
                photoPicker.modalPresentationStyle = .fullScreen
            
                self.present(photoPicker, animated: true, completion: nil)
            }
        }
        
        //nothing happens when the user cancels
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        
        //add the buttons to alert
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        //present alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //get the image picked by the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker .dismiss(animated: true, completion: nil)
        Rimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    
    
    //if "Add recipe is pressed, then the values in the textfields are put into variables"
    @IBAction func addRecipe(_ sender: Any) {
        Rtitle = titleField.text
        Rdescription = descriptionField.text
        Totalprice = gm.totalPrice
    }
    
    //if the cancel button is pressed, then the bolean value changes
    @IBAction func cancel(_ sender: Any) {
        cancelStatus = true
    }
    
    //placeholder code for TextView
    //If the user presses on the describtion field
    func textViewDidBeginEditing(_ textView: UITextView){
        
        //if the text equals the placeholder one, then the color is set back to black and the field is cleared
        if descriptionField.text! == "Enter your recipe description here!" {
            descriptionField.text = ""
            descriptionField.textColor = UIColor.black
        }
    }
    
    //keyboard func to minimize when the user touches anywhere else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    //This func identifies if the user entered all the information correctly before unwinding
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //if the user cancels, then it returns that the user can unwind
        if cancelStatus == true {
            return true
        }
        
        //If any of the fields are empty, then the user cant segue, it also checks if the descibtion field only has the placeholder text
        //Each empty field has its own error message
        if titleField.text == "" || descriptionField.text == "" || ingredients.isEmpty || Rimage == nil || descriptionField.text == "Enter your recipe description here!"{
            if titleField.text == "" {
                let alert = UIAlertController(title: "Missing Field", message: "Please Enter A Title For The Recipe", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel){ (action) in}
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else if descriptionField.text == "" || descriptionField.text == "Enter your recipe description here!" {
                let alert = UIAlertController(title: "Missing Field", message: "Please Enter A Description For The Recipe", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel){ (action) in}
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else if ingredients.isEmpty {
                let alert = UIAlertController(title: "Missing Field", message: "Please Enter Ingredients For The Recipe", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel){ (action) in}
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else if Rimage == nil {
                let alert = UIAlertController(title: "Missing Field", message: "Please Enter An Image For The Recipe", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel){ (action) in}
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            return false
        }
        
        //if both conditions are false, then the user unwinds
        return true
    }
    
    
    

}
