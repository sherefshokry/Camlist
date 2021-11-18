//
//  HTTPClient.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data,HTTPURLResponse)
    case failure(Error)
}


public protocol HTTPClient {
    func get(from url: URL,completion: @escaping (HTTPClientResult) -> ())
}
