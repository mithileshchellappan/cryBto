//
//  NetworkingManager.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 28/10/23.
//

import Foundation
import Combine

class NetworkingManager: Decodable{
    
    enum NetworkingError: LocalizedError {
        case badUrlResponse(url: URL)
        case unknown
        case rateLimited
        
        var errorDescription: String?{
            switch self {
            case .badUrlResponse(let url):
               return  "Bad Response from URL: \(url)"
            case .unknown:
                return "Unknown error"
            case .rateLimited:
                return "Request is rate limited."
            }
        }
        
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0,url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output,url: URL ) throws -> Data{
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            print(output.response)
            throw NetworkingError.badUrlResponse(url:url )
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}
