//
//  Array+remove.swift
//  Ozapftis
//
//  Created by Jeanette Müller on 14.12.23.
//

import Foundation

public extension Array where Element: Equatable {
    
    mutating func removeObject(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
