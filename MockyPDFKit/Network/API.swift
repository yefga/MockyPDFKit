//
//  API.swift
//  MockyPDFKit
//
//  Created by Yefga on 31/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import Foundation

typealias voidHandler = (() -> ())
typealias JSONDictionary = [String: String]

public class API {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    internal func request(completionHandler: @escaping (Result<Data, Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "mocky.io"
        components.path = "/v2/5d36642e5600006c003a52c1"
        
        
        var request: URLRequest!
        if let url = components.url {
            request = URLRequest(url: url)
            request.httpMethod = "GET"
            
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                
                fatalError("Data and error should never both be nil")
            }
            
            
            completionHandler(.success(data))
            
        }
        
        task.resume()
    }
    
}
