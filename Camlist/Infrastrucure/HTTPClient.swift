//
//  HTTPClient.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(from request: URLRequest,completion: @escaping (Result) -> ())
    //-> HTTPClientTask
}
