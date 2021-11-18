//
//  URLSessionHTTPClient.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation


import Foundation

public final class URLSessionHTTPClient : HTTPClient {
    
    private let session : URLSession
    
    public init(session : URLSession = .shared){
        self.session = session
    }
    
    private struct UnExpectedValuesRepresntation : Error {}
    
    public func get(from url: URL,completion: @escaping (HTTPClientResult) -> ()){
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data , let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            }
            else{
                completion(.failure(UnExpectedValuesRepresntation()))
            }
        }.resume()
        
    }
    
}
