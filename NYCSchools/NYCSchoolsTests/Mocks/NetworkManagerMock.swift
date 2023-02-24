//
//  NetworkManagerMock.swift
//  NYCSchoolsTests
//
//  Created by Sheetal on 2/24/23.
//

import Foundation
import Combine
@testable import NYCSchools

class NetworkManagerMock<T:Decodable>: NetworkManager {
    typealias CompletionHandler = (Result<T, Error>) -> Void
    // data and error can be set to provide data or an error
    var parsedTClass: T?
    var error: Error?
    var url: URL?
    
    override func makeGetRequest<T>(url: URL, type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        self.url = url
        if let error = self.error{
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(self.parsedTClass as! T))
        }
    }
    
    override func makeGetRequestWithFuture<T>(url: URL, type: T.Type) -> Future<T, Error> where T : Decodable {
        self.url = url
        return Future<T, Error> { promise in
            if let error = self.error{
                promise(.failure(error))
            } else {
                promise(.success(self.parsedTClass as! T))
            }
        }
    }
}
