//
//  NetworkManager.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import Foundation
import Logging
import Combine


class NetworkManager {
    
    // MARK: - Constants & Variables
    
    private let logger = Logger.initLogger()
    var anyCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    var urlSession: URLSession?
    let asynchrounsQueue = DispatchQueue.global(qos: .userInteractive)
    
    // MARK: - Computed Properties
    
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Initializers
    
    init(session: URLSession = URLSession.shared) {
        urlSession = session
    }
    
    // MARK: - Functions
    
    // Using Completion Handlers Result type of enum type T and Error
    func makeGetRequest<T:Decodable>(url: URL, type: T.Type, completionHandler: @escaping(Result<T, Error>) -> Void){
        asynchrounsQueue.async {
            let task = self.urlSession?.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    self.logger.e("URL session threw error: \(error)")
                    completionHandler(Result.failure(NetworkingError.transportError(error)))
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.logger.e("URL session threw HTTPURLResponse error \(url)")
                    completionHandler(Result.failure(NetworkingError.responseParseError))
                    return
                }
                if (200...299).contains(httpResponse.statusCode) {
                    if let data = data {
                        guard let parsedDataClass: T = try? self.jsonDecoder.decode(type, from: data) else {
                            self.logger.e("URL session threw parsing error of data")
                            completionHandler(Result.failure(NetworkingError.jsonParserError(error.debugDescription)))
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
            task?.resume()
        }
    }
    
    // API call using Combile's Future Publisher class. Just to compare how its easier and removes a lot of boilerplate code
    func makeGetRequestWithFuture<T:Decodable>(url: URL, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { promise in
            self.urlSession?.dataTaskPublisher(for: url)
                .tryMap() { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        self.logger.e("URL session threw HTTPURLResponse error \(url)")
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: T.self, decoder: self.jsonDecoder)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.logger.e("URL session threw error: \(error) for url: \(url)")
                        promise(.failure(error))
                    }
                }, receiveValue: { promise(.success($0))} )
                .store(in: &self.anyCancellables)
        }
    }
}
