//
//  StringExtension.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

extension String {
    func trunc(length: Int, trailing: String = "…") -> String {
        let maxLength = length - trailing.count
        guard maxLength > 0, !self.isEmpty, self.count > length else {
            return self
        }
        return self.prefix(maxLength) + trailing
    }
}
