//
//  DetailController.swift
//  Recipes & Groceries
//
//  Created by Rakan Alshubat on 11/5/18.
//  Copyright © 2018 Rakan Alshubat. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var IngredientsTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var RecipePhoto:UIImage?
    var RecipeTitle:String?
    var RecipeIngredients:String?
    var RecipeDescription:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecipeImage.image = RecipePhoto
        TitleLabel.text = RecipeTitle
        IngredientsTextView.text = RecipeIngredients
        descriptionTextView.text = RecipeDescription
    }

}
