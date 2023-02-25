//
//  SchoolsViewModeltests.swift
//  NYCSchoolsTests
//
//  Created by Sheetal on 2/24/23.
//

import XCTest
@testable import NYCSchools

class SchoolsViewModelTests: XCTestCase {
    
    func testfetchSchoolsFails() throws {
        // Given
        let networkManager = NetworkManagerMock<[School]>()
        
        // Injecting  NetworkManagerMock to The ViewModel
        let schoolsViewModel = SchoolsViewModel(networkManager: networkManager)
        let customError = NetworkingError.jsonParserError("Some Random Error")
        // We assign a error to the mock networkManager
        networkManager.error = customError
        
        // When
        schoolsViewModel.fetchSchools()
        
        // Then
        XCTAssertEqual(schoolsViewModel.alertErrorMessage, customError.localizedDescription)
    }
    
    func testfetchSchoolsSuceeds() throws {
        // Given
        let networkManager = NetworkManagerMock<[School]>()
        // Injecting  NetworkManagerMock to The ViewModel
        let schoolsViewModel = SchoolsViewModel(networkManager: networkManager)
        // We assign a mocked school to the success block in networkManager
        let mock_schools = [School(dbn: "XCT", name: "TestSchool", overview: "overview", location: "address", phone_number: "", fax_number: "", email: "", website: "")]
        networkManager.parsedTClass = mock_schools
        
        // When
        schoolsViewModel.fetchSchools()
        
        // Then
        XCTAssertEqual(schoolsViewModel.alertErrorMessage, nil)
        XCTAssertEqual(mock_schools.count, schoolsViewModel.schools.count)
        XCTAssertEqual(mock_schools.first, schoolsViewModel.schools.first)
    }
}
