//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import Foundation
import Combine

class SchoolsViewModel {
    
    // MARK: Properties
    
    @Published var schools: [School] = []
    @Published var alertErrorMessage: String?

    // MARK: Helper Functions
    
    func fetchSchools(
        limit:Int = IntegerConstants.defaultPaginationBatchSize.rawValue,
        offset:Int = 0) {
        
        var schoolURL = URL(string: URLs.schoolURL.description)!
        schoolURL.appendQueryItem(name: "$limit", value: String(limit))
        schoolURL.appendQueryItem(name: "$offset", value: String(offset))
        NetworkManager.shared.makeGetRequest(url: schoolURL, type: [School].self) { result in
            switch result {
            case .success(let schools):
                self.schools.append(contentsOf: schools)
            case .failure(let error):
                self.alertErrorMessage = error.localizedDescription
            }
        }
    }
}
