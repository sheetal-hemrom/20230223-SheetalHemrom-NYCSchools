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
    
    
    private let logger = Logger.initLogger()
    var anyCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    var networkManager: NetworkManager?
    
    // MARK: Initializers
    
    // Injecting NetworkManager for UnitTesting
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Helper Functions
    
    func fetchSchoolScoreForDbn(dbn: String) {
        
        var schoolScoreURL = StringURLs.schoolDetailURL.url
        schoolScoreURL.appendQueryItem(name: "dbn", value: dbn)
        self.networkManager?.makeGetRequestWithFuture(url: schoolScoreURL, type: [SchoolScore].self)
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

