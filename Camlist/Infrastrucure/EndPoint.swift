//
//  ApiEndPoint.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//
import Foundation

public enum HTTPMethodType: String {
    case get = "GET"
}

public final class Endpoint {
    private init() {}
    
    public static func url(path: String,method: HTTPMethodType = .get,queryItems: [URLQueryItem]) -> URLRequest {
        let baseURL = URL(string: AppConfigrution().baseUrl)!
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = baseURL.path + path
        components.queryItems = [
            URLQueryItem(name: "client_id", value: AppConfigrution().clientID),
            URLQueryItem(name: "client_secret", value: AppConfigrution().clientSecret),
            URLQueryItem(name: "v", value: AppConfigrution().apiVersion),
          ]
        components.queryItems?.append(contentsOf: queryItems)

        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        return request
        }
    }

