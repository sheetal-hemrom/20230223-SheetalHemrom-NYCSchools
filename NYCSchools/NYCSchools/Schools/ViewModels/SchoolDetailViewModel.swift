//
//  SchoolScoreViewModel.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import Foundation
import Logging
import Combine

class SchoolDetailViewModel {
    
    // MARK: Properties

    @Published var schoolScore: SchoolScore?
    @Published var school: School?
    @Published var alertErrorMessage: String?
    
    private let logger = Logger(label: Bundle.main.displayName ?? StringConstants.appName.rawValue)
    var anyCancellables : Set<AnyCancellable> = Set<AnyCancellable>()

    
    // MARK: Helper Functions
    
    func fetchSchoolScoreForDbn(dbn: String) {
        
        let schoolScoreURL = URL(string: URLs.schoolDetailURL(dbn: dbn).description)!
        NetworkManager.shared.makeGetRequestWithFuture(url: schoolScoreURL, type: [SchoolScore].self)
            .sink { completion in
                switch completion {
                 case .failure(let error):
                    self.alertErrorMessage = error.localizedDescription
                case .finished:
                    self.logger.d("Finished loading score for dbn:\(dbn)")
                }
            } receiveValue: { scores in
                    self.schoolScore = scores.count > 0 ? scores.first :  nil
            }.store(in: &self.anyCancellables)
    }

}

