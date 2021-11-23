//
//  VenueApiEndToEndTests.swift
//  VenueApiEndtoEndTests
//
//  Created by SherifShokry on 23/11/2021.
//

import XCTest
import Camlist

class VenueApiEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGetVenueResult_matchesFixedTestLimitData(){
        let url = URL(string:"https://api.foursquare.com/v3/places/search?v=20190425&radius=1000&ll=30.0511,31.2126&limit=5")!
           var urlRequest = URLRequest(url: url)
           urlRequest.addValue("fsq3i7zLlSfxIcEDGcdVZovKT9XZpi3wZGmDCSSD30p/lkA=", forHTTPHeaderField: "Authorization")
           let client = URLSessionHTTPClient()
           let loader = RemoteVenueLoader(client: client, venueResponseStorage: nil, urlRequest: urlRequest)
           trackForMemoryLeaks(client)
           trackForMemoryLeaks(loader)
           let exp = expectation(description: "Wait for load completion")
   
           var receivedResult : Result<[Venue],Error>?
           loader.fetchVenueList{ result in
               receivedResult = result
               exp.fulfill()
           }
   
           wait(for: [exp], timeout: 5)
   
           switch receivedResult {
           case let .success(receivedVenueItems):
               XCTAssertEqual(receivedVenueItems.count, 5 , "Expected 5 items according to limit number")
           case let .failure(error):
               XCTFail("expected success,got \(error) instead")
           default:
               XCTFail("expected success,got no result instead")
           }
    }
    
}

