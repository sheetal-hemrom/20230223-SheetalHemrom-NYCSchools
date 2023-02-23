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


enum StringConstants: CustomStringConvertible {
    case appName
    case schoolCellIdentifier
    case genericError
}

extension StringConstants {
    var description: String {
        switch self {
        case .appName: return "NYCSchools"
        case .schoolCellIdentifier: return "school_cell"
        case .genericError: return "Something went wrong! Please try again later"
        }
    }
}

// NetworkingError with associated values
enum NetworkingError: Error {
    case transportError(Error)
    case serverSideError(Int)
    case responseParseError
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .transportError(_):
            return "Transport error between urlsession elements"
        case .serverSideError(let error):
            return "Server returned error: \(error.description)"
        case .responseParseError:
            return "Response returned by server is invalid"
        }
    }
}
