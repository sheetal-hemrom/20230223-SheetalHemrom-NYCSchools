//
//  LoggerExtension.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import Logging

extension Logger {
    func e(_ msg: String, file: String = #fileID, line: Int = #line) {
        let pos = "\(file.split(separator: "/").last!):\(line)"
        self.error("\(pos): \(msg)")
    }
    func c(_ msg: String, file: String = #fileID, line: Int = #line) {
        let pos = "\(file.split(separator: "/").last!):\(line)"
        self.critical("\(pos): \(msg)")
    }
    func d(_ msg: String, file: String = #fileID, line: Int = #line) {
        let pos = "\(file.split(separator: "/").last!):\(line)"
        self.debug("\(pos): \(msg)")
    }
    func i(_ msg: String, file: String = #fileID, line: Int = #line) {
        let pos = "\(file.split(separator: "/").last!):\(line)"
        self.info("\(pos): \(msg)")
    }
}


