//
//  URLSessionMock.swift
//  NYCSchoolsTests
//
//  Created by Sheetal on 2/24/23.
//

import Foundation

@testable import NYCSchools

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    // data and error can be set to provide data or an error
    var data: Data?
    var error: Error?
    var httpResponse: HTTPURLResponse?
    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
        ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let httpResponse = self.httpResponse
        return URLSessionDataTaskMock {
            completionHandler(data, httpResponse, error)
        }
    }
}
