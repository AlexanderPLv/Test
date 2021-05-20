//
//  NetworkManager.swift
//  Test
//
//  Created by Alexander Pelevinov on 16.05.2021.
//

import Foundation

class NetworkManager {
    
    private let httpBody = HttpBody(uid: "563B4852-6D4B-49D6-A86E-B273DD520FD2",
                                    type: "ExchangeRates",
                                    rid: "BEYkZbmV")
    
    private let baseURL = "alpha.as50464.net"
    private let path = "/moby-pre-44/core"
    private let port = 29870
    private var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.port = port
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "r", value: "BEYkZbmV"),
            URLQueryItem(name: "d", value: "563B4852-6D4B-49D6-A86E-B273DD520FD2"),
            URLQueryItem(name: "t", value: "ExchangeRates"),
            URLQueryItem(name: "v", value: "44")
        ]
        return components.url!
    }
    
    func getCurrencyList(withCompletion completion: @escaping (Result<Response, NetworkingError>) -> Void) {
        let session = URLSession(configuration: .default,
                                 delegate: nil,
                                 delegateQueue: .main)
        do {
            let request = try self.buildRequest()
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(.failure(NetworkingError.invalidRequest))
                }
                guard let data = data else {
                    completion(.failure(NetworkingError.badData))
                    return
                }
                do {
                    let value = try JSONDecoder().decode(Response.self, from: data)
                                    completion(.success(value))
                } catch {
                    completion(.failure(NetworkingError.parsingError))
                }
            })
            task.resume()
        } catch {
            completion(.failure(NetworkingError.invalidRequest))
        }
    }
    
    private func buildRequest() throws -> URLRequest {
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
        request.httpMethod = "POST"
        do {
            try encode(urlRequest: &request)
        } catch let error {
            throw error
        }
        return request
    }
    
    private func encode(urlRequest: inout URLRequest) throws {
        do {
            let jsonAsData = try httpBody.toData()
            urlRequest.httpBody = jsonAsData
            urlRequest.setValue("Test GeekBrains iOS 3.0.0.182 (iPhone 11; iOS 14.4.1; Scale/2.00; Private)",
                                forHTTPHeaderField: "User-Agent")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        } catch {
            throw NetworkingError.encodingFailed
        }
    }
    
}
