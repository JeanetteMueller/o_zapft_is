//
//  String+localized.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 15.12.23.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
