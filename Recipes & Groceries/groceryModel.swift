//
//  groceryModel.swift
//  Recipes & Groceries
//
//  Created by Rakan Alshubat on 11/16/18.
//  Copyright © 2018 Rakan Alshubat. All rights reserved.
//

import Foundation

public class groceryModel {
    
    var rm:RecipeModel = RecipeModel();
    var totalPrice = [Double]()
    
    //This func returns a string of all the ingredients in a single recipe.
    //This func gets an array that has each ingredient in an index with its measurments, seperated by a "-"
    //example: ["2-lb-cheese", "3-lb-beef"]
    func getIngredients(ingredients:Array<String>) -> String{
        
        //initialize empty string
        var seperatedWords:String = ""
        
        //loop through the contents of the passed array
        for i in 0..<(ingredients.count) {
            
            //split the three components of each ingredient from each other
            let seperatedList = ingredients[i].split(separator: "-")
            
            //loop through the three components and put a space between them
            for j in 0..<3 {
                seperatedWords = seperatedWords + seperatedList[j] + " "
            }
            
            //add a new line for the next ingredient
            seperatedWords = seperatedWords + "\n"
        }
        
        //return list of ingredients as a string
        return seperatedWords
    }
    
    
    //This function returns a string of all the ingredients from all the recipes
    //If an ingredient is repeated, then the amount gets added together and displayed as one
    func getGroceryList() -> String{
        
        //initialize arrays for the ingredients and thier info
        var amount = [String]()
        var measurment = [String]()
        var ingredient = [String]()
        
        //get the number of recipes in CoreData
        let count = rm.fetchRecords()
        
        //loop through every recipe
        for i in 0..<count {
            
            //get the ingredients of a recipe
            let recipesList = rm.fetchedResults[i].recipeIngredients
            
            //loop through every ingredient
            for j in 0..<(recipesList!.count){
                
                //seperate the components of an ingredien
                let seperatedIngredients = recipesList![j].split(separator: "-")
                
                //if the array of ingredients is empty (which means all arrays are empty)
                //append the first ingredient.
                if ingredient.isEmpty{
                    amount.append(String(seperatedIngredients[0]))
                    measurment.append(String(seperatedIngredients[1]))
                    ingredient.append(String(seperatedIngredients[2]))
                //if its not the first ingredient, it goes through the 'else'
                }else{
                    
                    //if the list of ingredients has a match with the new ingredient
                    if ingredient.contains(String(seperatedIngredients[2])){
                        
                        //loop through all the ingredients to find which index the match is
                        for q in 0..<ingredient.count {
                            
                            //if the match is found, the amount at the matched index will add
                            //the amount of the new ingredient
                            if ingredient[q] == seperatedIngredients[2]{
                                amount[q] = String(Double(seperatedIngredients[0])! + Double(amount[q])!)
                            }
                        }
                    
                    //if theres no match, then the new ingredient is added to the arrays
                    }else{
                        amount.append(String(seperatedIngredients[0]))
                        measurment.append(String(seperatedIngredients[1]))
                        ingredient.append(String(seperatedIngredients[2]))
                    }
                }
            }
        }
        
        //initialize an empty string
        var groceries:String = ""
        
        //loop through all the ingredients from all the recipes and put them in a single string
        for n in 0..<ingredient.count{
            groceries = groceries + "\n" + amount[n] + " " + measurment[n] + " " + ingredient[n]
        }
        
        //return the string
        return groceries
    }
    
    
    
    //This function adds the price of items added to an array of estimated prices for the items added
    func getGroceryPrice(ingredient:String){
    
        let ing = ingredient.replacingOccurrences(of: " ", with: "-")
        
        let urlString = "http://api.walmartlabs.com/v1/search?apiKey=ejyzxuxahukwt3ckmzhfewb7&categoryId=976759&query=\(ing)&sort=bestseller"
        let url = URL(string: urlString)!
        let urlSession = URLSession.shared
        
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            var jsonResults = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            
            let numOfItems = jsonResults["totalResults"] as! Int
            
            if numOfItems > 0 {
                let items = jsonResults["items"] as! NSArray
                let info = items[0] as? [String:AnyObject]
                let price = info!["salePrice"] as! Double
            
                //append the array with the cost of each item
                self.totalPrice.append(price)
            }
        })
        jsonQuery.resume()
        
    }
    
    //gets the stored prices for each recipe and combines them
    func getTotalPrice() -> String {
        
        var price:Double = 0.00
        let count = rm.fetchRecords()
        
        //loop through every recipe
        for i in 0..<count {
            let recipes = rm.fetchedResults[i].recipePrice
            
            //loop through every price in a recipe
            for j in 0..<recipes!.count {
                price = price + recipes![j]
            }
        }
        
        //formats the string and returns it
        let total = "$\(price)*"
        return total
    }
    
    
}
