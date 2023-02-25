//
//  NetworkManagerTests.swift
//  NYCSchoolsTests
//
//  Created by Sheetal on 2/25/23.
//

import Foundation
import XCTest
import Combine
@testable import NYCSchools

class NetworkManagerTests: XCTestCase {
    
    let mockUrlSession = URLSessionMock()
    var networkManager:NetworkManager?
    var anyCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func setUp() {
        // Injecting  URLSessionMock to The NetworkManager
        networkManager = NetworkManager(session: mockUrlSession)
    }
    
    
    override func tearDownWithError() throws {
        mockUrlSession.error = nil
        mockUrlSession.data = nil
    }
    
    func testMakeGetRequestFailsWhenURLSessionThrowsError() throws {
        
        // Given
        let url = URL(string: "https://google.com")!
        let mock_error = NetworkingError.serverSideError(400)
        // We assign a error to urlsession mock which should be handled by NetworkManager
        mockUrlSession.error = mock_error
        mockUrlSession.httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let exp = expectation(description: "Loading URL")
        networkManager?.makeGetRequest(url: url, type: [School].self) { result in
            switch result {
            case .success(_):
                XCTFail("Should not reach success block")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkingError, NetworkingError.transportError(mock_error))

            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMakeGetRequestFailsWhenThereIsJsonParsingError() throws {
        
        // Given
        let url = URL(string: "https://google.com")!
        let mock_error = NetworkingError.jsonParserError("nil")
        // We assign a invalid json for the T class to urlsession mock which should be handled by NetworkManager
        let invalid_json =
            """
                {
                    "dbn": "01M292",
                    "school_name": "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES",
                    "num_of_sat_test_takers": "29",
                    "sat_critical_reading_avg_score": "355",
                    "sat_math_avg_score": "404",
                    "sat_writing_avg_score": "363"
                }
            """
        mockUrlSession.data = Data(invalid_json.utf8)
        mockUrlSession.httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let exp = expectation(description: "Loading URL")
        
        // When/Then
        networkManager?.makeGetRequest(url: url, type: [School].self) { result in
            switch result {
            case .success(_):
                XCTFail("Should not reach success block")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkingError, mock_error)

            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMakeGetRequestSuceeds() throws {
        
        // Given
        let url = URL(string: "https://google.com")!
        // We assign data to urlsession mock which should be handled by NetworkManager
        mockUrlSession.data = dataFromFile()
        mockUrlSession.httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let exp = expectation(description: "Loading URL")
        
        // When/Then
        networkManager?.makeGetRequest(url: url, type: [School].self) { result in
            switch result {
            case .success(let schools):
                XCTAssertTrue(schools.first?.dbn == "21K728")
            case .failure(_):
                XCTFail("Should not reach the failure block")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

// MARK: - Helper Functions

extension NetworkManagerTests {
    func dataFromFile(file: String="school") -> Data? {
        var url: URL?
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            url = bundle.url(forResource: file, withExtension: "json")
            guard let url = url, let data = try? Data(contentsOf: url) else {
                fatalError("Failed to load \(file) from bundle.")
            }
            return data
        }
        return nil
    }
}
