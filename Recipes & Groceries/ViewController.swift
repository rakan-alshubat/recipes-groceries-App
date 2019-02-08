//
//  ViewController.swift
//  Recipes & Groceries
//
//  Created by Rakan Alshubat on 11/3/18.
//  Copyright © 2018 Rakan Alshubat. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recipeTable: UITableView!
    
    //access the models and their functions
    var rm:RecipeModel = RecipeModel();
    var gm:groceryModel = groceryModel();
    var groceryPrice:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipeTable.reloadData()
    }
    
    
    //prepare segues to the recipe detail view and the grocery List view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if the segue is to the detail view
        if (segue.identifier == "toDetails"){
            
            //get the selected index
            let selectedIndex:IndexPath = self.recipeTable.indexPath(for: sender as! UITableViewCell)!
            
            //get the photo, title, and describtion
            let Rpicture = rm.fetchedResults[selectedIndex.row].recipePhoto
            let Rname = rm.fetchedResults[selectedIndex.row].recipeTitle
            let Rdesc = rm.fetchedResults[selectedIndex.row].recipeDescribtion

            //get the ingredient as an array
            let ingredientArray:Array = rm.fetchedResults[selectedIndex.row].recipeIngredients!
            
            //take the array and send it to groceryModel to get back a string of the ingredients
            let ingredientList:String = gm.getIngredients(ingredients: ingredientArray)
            
            //send the recipe details to the detail View
            let detailView = segue.destination as! DetailController
            detailView.RecipePhoto = UIImage(data: Rpicture! as Data)
            detailView.RecipeTitle = Rname
            detailView.RecipeIngredients = ingredientList
            detailView.RecipeDescription = Rdesc
            
        }
        
        //if the segue is to the grocery list view
        if (segue.identifier == "toList"){
            
            //get the groceryList back as a string
            let groceryList = gm.getGroceryList()
            
            let groceryPrice = gm.getTotalPrice()
            
            //send the data to the grocery list view
            let listView = segue.destination as! GroceryController
            listView.list = groceryList
            listView.price = groceryPrice
        }
        
    }
    
    
    //If The user cancels his recipe entry, then nothing happens
    @IBAction func cancelUnwind(segue: UIStoryboardSegue){
    }
    
    
    //if the user adds the recipe, this gets excuted.
    @IBAction func UnwindToView(segue: UIStoryboardSegue){
        
        //if the unwind is from the adder controller
        if let returned = segue.source as? AdderController {
            
            //turn image to appropriate data for CoreData
            let img:NSData = returned.Rimage!.pngData()! as NSData
            
            //add the title, describtion, ingredients, and photo to CoreData
            rm.addRecipe(title: returned.Rtitle!, ingredients: returned.ingredients, description: returned.Rdescription!, image: img, price: returned.Totalprice)
            
            
            //save the new entry to CoreData
            do {
                try rm.managedObjectContext.save()
            } catch _ {
                //Custom Alert will pop-up if an error occurs
                let alert = UIAlertController(title: "Error", message: "Could Not Save The Recipe", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel){ (action) in}
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        //reload the table to show the new entry
        recipeTable.reloadData()
    }

    
    //get back the number of recipes in CoreData to get the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rm.fetchRecords()
    }
    
    //The next sections allows the user to swipe to delete items from his table, and CoreData
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            rm.removeRecipe(row: indexPath.row)
            recipeTable.reloadData()
        }
    }
    //End of delete section
    
    
    //populate each cell in the table view with the recipe title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let rowData = rm.getRecipeObject(row: indexPath.row)
        cell.textLabel?.text = rowData.recipeTitle
        return cell
    }
    
    

}

