//
//  HTTPURLResponse+StatusCode.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
