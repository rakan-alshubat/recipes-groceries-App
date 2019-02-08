//
//  RecipeModel.swift
//  Recipes & Groceries
//
//  Created by Rakan Alshubat on 11/6/18.
//  Copyright © 2018 Rakan Alshubat. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class RecipeModel {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResults = [Recipes]()
    
    //gets the number of records in CoreData
    func fetchRecords() -> Int {
        var x = 0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        fetchedResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Recipes])!
        x = fetchedResults.count
        return x
    }
    
    //deletes the item thats the user selected
    func removeRecipe(row:Int){
        managedObjectContext.delete(fetchedResults[row])
        fetchedResults.remove(at: row)
        do{
            try managedObjectContext.save()
        } catch {}
    }
    
    //gets the recipe object selected
    func getRecipeObject(row:Int) -> Recipes {
        return fetchedResults[row]
    }
    
    func addRecipe(title:String, ingredients:[String], description:String, image:NSData, price:[Double]){
        let ent = NSEntityDescription.entity(forEntityName: "Recipes", in: managedObjectContext)
        let newItem = Recipes(entity: ent!, insertInto: managedObjectContext)
        

        //add the title, describtion, ingredients, price and photo to CoreData
        newItem.recipeTitle = title
        newItem.recipeIngredients = ingredients
        newItem.recipeDescribtion = description
        newItem.recipePhoto = image
        newItem.recipePrice = price
    }
    
}
