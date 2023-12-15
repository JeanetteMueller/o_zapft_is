//
//  BeerType.swift
//  Ozapftis
//
//  Created by Jeanette Müller on 14.12.23.
//

import Foundation
import SwiftData


class BeerType: NSObject, Decodable {
    @Attribute(.unique) var id: Int
    var name: String
    //    var tagline: String?
    var desc: String?
    var imageUrl: String?
    
    var abv: Float?
    var ibu: Float?
    var ebc: Float?
    var srm: Float?
    var ph: Float?
    var ingredients: BeerIngredients?
    var foodPairing: [String]?
    
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, desc = "description", imageUrl = "image_url", abv, ibu, ebc, srm, ph, ingredients, foodPairing = "food_pairing"
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        desc = try? values.decode(String.self, forKey: .desc)
        imageUrl = try? values.decode(String.self, forKey: .imageUrl)
        
        abv = try? values.decode(Float.self, forKey: .abv)
        ibu = try? values.decode(Float.self, forKey: .ibu)
        ebc = try? values.decode(Float.self, forKey: .ebc)
        srm = try? values.decode(Float.self, forKey: .srm)
        ph = try? values.decode(Float.self, forKey: .ph)
        
        do {
            ingredients = try values.decode(BeerIngredients.self, forKey: .ingredients)
        }catch{
            print("ERROR: \(error.localizedDescription)")
        }
        foodPairing = try? values.decode([String].self, forKey: .foodPairing)
    }
    
    struct BeerIngredients: Decodable {
        var malt: [BeerIngredientItem]?
        var hops: [BeerIngredientItem]?
        var yeast: String?
        
        struct BeerIngredientItem: Decodable {
            var name: String
            var amount: Amount?
            
            struct Amount: Decodable {
                var value: Float
                var unit: String
            }
        }
    }
}
