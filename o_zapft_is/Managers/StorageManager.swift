//
//  StorageManager.swift
//  Ozapftis
//
//  Created by Jeanette Müller on 14.12.23.
//

import Foundation

extension Notification.Name {
    static let StorageManagerDidChange  = Notification.Name("StorageManagerDidChange")
}

class StorageManager {
    
    static let shared: StorageManager = {
        
        let instance = StorageManager()
        
        return instance
    }()
    
    init() {
        self.beer = [BeerType]()
        
        updateFromDownload()
    }
    
    var beer: [BeerType]
    
    func getAllBeer() -> [BeerType] {
        return self.beer
    }
    
    func getBeerInColorRange(min: Float, max: Float) -> [BeerType] {
        
        if max >= 40.0 {
            return self.beer.filter( { ($0.srm ?? 0) >= min })
        }
        
        return self.beer.filter( { ($0.srm ?? 0) >= min && ($0.srm ?? 0) <= max })
    }
    
    func updateFromDownload() {
        DispatchQueue.global(qos: .background).async {
            
            let targetPath = Networker.getLocalPathFor(apiEndPoint)
            
            if FileManager.default.fileExists(atPath: targetPath) {
                
                do {
                    let jsonData = try Data(contentsOf: URL(fileURLWithPath: targetPath))
                    
                    let jsonDecoder = JSONDecoder()
                    
                    let result = try jsonDecoder.decode([BeerType].self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.beer = result
                        
                        NotificationCenter.default.post(name: .StorageManagerDidChange, object: nil)
                    }
                    
                }catch {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getBeerColorSteps() -> [Float] {
        
        var values = self.beer.map({ (beer: BeerType) -> Float in
            beer.srm ?? 0.0
        })
        
        let bridgeSet: Set<Float> = Set(values)
        values = Array(bridgeSet)
        values.sort()
        
        if values.first == 0.0 {
            values.removeFirst()
        }
        
        return values
    }
}
