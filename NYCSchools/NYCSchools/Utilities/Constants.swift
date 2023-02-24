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

enum URLs: CustomStringConvertible {
    case schoolURL
    case schoolDetailURL(dbn: String)
}
extension URLs {
    var description: String {
        switch self {
        case .schoolURL:
            return "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
        case .schoolDetailURL(let dbn):
            return "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?dbn=\(dbn)"
        }
    }
}


enum StringConstants: String {
    case appName = "NYCSchools"
    case schoolCellIdentifier = "school_cell"
    case genericError = "Something went wrong! Please try again later"
    case sequeShowDetail = "showDetail"
    case noScoresMessage = "No scores available!"
}

enum IntegerConstants: Int {
    case defaultPaginationBatchSize = 5
}



// NetworkingError with associated values
enum NetworkingError: Error {
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
