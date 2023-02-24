//
//  NSAttributedStringExtension.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import Foundation

extension NSAttributedString {
    
    func replacing(placeholder:String, with valueString:String) -> NSAttributedString {
        
        if let range = self.string.range(of:placeholder) {
            let nsRange = NSRange(range,in:valueString)
            let mutableText = NSMutableAttributedString(attributedString: self)
            mutableText.replaceCharacters(in: nsRange, with: valueString)
            return mutableText as NSAttributedString
        }
        return self
    }
  
}
