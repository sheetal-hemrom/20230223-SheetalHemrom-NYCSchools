//
//  SchoolDetailsViewModel.swift
//  NYCSchoolsTests
//
//  Created by Sheetal on 2/25/23.
//

import XCTest
@testable import NYCSchools

class SchoolDetailsViewModelTests: XCTestCase {
    
    func testfetchSchoolScoreForDbnFails() throws {
        // Given
        let networkManager = NetworkManagerMock<[SchoolScore]>()
        // Injecting  NetworkManagerMock to The ViewModel
        let schoolDetailsViewModel = SchoolDetailViewModel(networkManager: networkManager)
        let customError = NetworkingError.jsonParserError("Some Random Error")
        // We assign a error to the mock networkManager
        networkManager.error = customError
        
        // When
        schoolDetailsViewModel.fetchSchoolScoreForDbn(dbn: "XCTY")
        
        // Then
        XCTAssertEqual(schoolDetailsViewModel.alertErrorMessage, customError.localizedDescription)
    }
    
    func testfetchSchoolScoreForDbnSuceeds() throws {
        // Given
        let networkManager = NetworkManagerMock<[SchoolScore]>()
        // Injecting  NetworkManagerMock to The ViewModel
        let schoolDetailsViewModel = SchoolDetailViewModel(networkManager: networkManager)
        // We assign a mocked school to the success block in networkManager
        let mock_school_scores = [SchoolScore(dbn: "XCTY", num_of_sat_test_takers: "2", sat_critical_reading_avg_score: "45", sat_math_avg_score: "56", sat_writing_avg_score: "90")]
        networkManager.parsedTClass = mock_school_scores
        
        // When
        schoolDetailsViewModel.fetchSchoolScoreForDbn(dbn: "XCTY")
        
        // Then
        XCTAssertEqual(schoolDetailsViewModel.alertErrorMessage, nil)
        XCTAssertEqual(mock_school_scores.first, schoolDetailsViewModel.schoolScore)
        
        // Test if url has the dbn query
        var schoolScoreURL = StringURLs.schoolDetailURL.url
        schoolScoreURL.appendQueryItem(name: "dbn", value: mock_school_scores.first?.dbn)
        XCTAssertEqual(networkManager.url, schoolScoreURL)
    }
}
