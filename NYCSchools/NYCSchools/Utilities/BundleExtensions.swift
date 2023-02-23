//
//  BundleExtensions.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import Foundation

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
