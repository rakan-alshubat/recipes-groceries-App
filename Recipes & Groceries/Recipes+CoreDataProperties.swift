//
//  Recipes+CoreDataProperties.swift
//  Recipes & Groceries
//
//  Created by Rakan Alshubat on 11/19/18.
//  Copyright © 2018 Rakan Alshubat. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipes> {
        return NSFetchRequest<Recipes>(entityName: "Recipes")
    }

    @NSManaged public var recipeDescribtion: String?
    @NSManaged public var recipeIngredients: [String]?
    @NSManaged public var recipePhoto: NSData?
    @NSManaged public var recipeTitle: String?
    @NSManaged public var recipePrice: [Double]?

}
