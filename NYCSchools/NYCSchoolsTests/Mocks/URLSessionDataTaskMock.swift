//
//  URLSessionDataTaskMock.swift
//  NYCSchoolsTests
//
//  Created by Sheetal on 2/24/23.
//

import Foundation

@testable import NYCSchools

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    // override resume and call the closure

    override func resume() {
        closure()
    }
}
