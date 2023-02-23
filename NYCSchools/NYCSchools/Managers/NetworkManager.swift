//
//  NetworkManager.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import Foundation
import Logging

class NetworkManager {
    
    // MARK: - Constants & Variables
    
    private let logger = Logger(label: Bundle.main.displayName ?? StringConstants.appName.description)
    
    // MARK: - Computed Properties

    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Functions

    // Using Completion Handlers Result type of enum type T and Error
    func makeGetRequest<T:Decodable>(url: URL, classType: T.Type, completionHandler: @escaping(Result<T, Error>) -> Void){
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                self.logger.e("URL session threw error: \(error)")
                completionHandler(Result.failure(NetworkingError.transportError(error)))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(Result.failure(NetworkingError.responseParseError))
                return
            }
            if (200...299).contains(httpResponse.statusCode) {
                if let data = data {
                    guard let parsedDataClass: T = try? self.jsonDecoder.decode(classType, from: data) else {
                        self.logger.e("URL session threw parsing error of data")
                        completionHandler(Result.failure(NetworkingError.responseParseError))
                        return
                    }
                    completionHandler(Result.success(parsedDataClass))
                }
            }
            else {
                self.logger.e("URL session threw non 2** status code: \(httpResponse.statusCode)")
                completionHandler(Result.failure(NetworkingError.serverSideError(httpResponse.statusCode)))
            }
        })
        task.resume()
    }
}
