//
//  Constants.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import Foundation

public protocol CustomStringConvertible {
    /// A textual representation of `self`.
    var description: String { get }
}

enum StringURLs: String {
    case schoolURL
    case schoolDetailURL
}
extension StringURLs {
    var url: URL {
        switch self {
        case .schoolURL:
            return URL(string: "resource/s3k6-pzi2.json", relativeTo: URL(string: StringConstants.baseURL.rawValue)!)!
        case .schoolDetailURL:
            return URL(string: "resource/f9bf-2cp4.json", relativeTo: URL(string: StringConstants.baseURL.rawValue)!)!
        }
    }
}


enum StringConstants: String {
    
    // MARK: String Constants
    case appName = "NYCSchools"
    case genericError = "Something went wrong! Please try again later"
    case noScoresMessage = "No scores available!"
    case loaderMessage = "loading ..."
    case defaultConfiguration = "Default Configuration"
    case baseURL = "https://data.cityofnewyork.us"
    
    // MARK: Identifiers
    case schoolCellIdentifier = "school_cell"
    case sequeShowDetail = "showDetail"
}

enum IntegerConstants: Int {
    case defaultPaginationBatchSize = 5
}


// NetworkingError with associated values
enum NetworkingError: Error, Equatable {
    
    static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
    
    case transportError(Error)
    case serverSideError(Int)
    case jsonParserError(String)
    case responseParseError
    case responseError
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .transportError(let error):
            return "Transport error between urlsession elements: \(error.localizedDescription)"
        case .serverSideError(let status):
            return "Server returned error: \(status)"
        case .responseParseError:
            return "Response returned by server is invalid"
        case .responseError:
            return "Server did not return proper response"
        case .jsonParserError(let message):
            return "Json parsing failed with error \(message)"
        }
    }
}
