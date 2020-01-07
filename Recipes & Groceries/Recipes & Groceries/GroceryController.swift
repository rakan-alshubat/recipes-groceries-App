//
//  GroceryController.swift
//  Recipes & Groceries
//
//  Created by Rakan Alshubat on 11/5/18.
//  Copyright © 2018 Rakan Alshubat. All rights reserved.
//

import UIKit

class GroceryController: UIViewController {

    @IBOutlet weak var groceryList: UITextView!
    @IBOutlet weak var groceryPrice: UILabel!
    
    var list:String = ""
    var price:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If the list or the price are empty, then display this. otherwise, display the list and price
        if list == "" || price == ""{
            groceryList.text = "You Have Not Entered Any Recipes"
            groceryPrice.text = "$0.00*"
        }else{
            groceryList.text = list
            groceryPrice.text = price
        }
    }
    
}
