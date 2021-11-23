//
//  RemoteVenuesLoaderTest.swift
//  CamlistTests
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation
import XCTest
import Camlist


class RemoteVenueLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let (_,client) = makeSUT()
        
        XCTAssertEqual(client.requestedUrls, [])
    }
    
    func test_load_requestDataFromURL(){
        let urlRequest = anyURLRequest()
        let (sut,client) = makeSUT()
        
        sut.fetchVenueList{_ in}
        
        XCTAssertEqual(client.requestedUrls, [urlRequest])
    }
    
    
    func test_loadTwice_LoadRequestTwice(){
        let urlRequest = anyURLRequest()
        let (sut,client) = makeSUT()
        
        sut.fetchVenueList{_ in}
        sut.fetchVenueList{_ in}
        
        XCTAssertEqual(client.requestedUrls, [urlRequest,urlRequest])
    }
    
    
    func test_load_deliversErrorWhenClientError(){
        let (sut,client) = makeSUT()
        let expectedError = NetworkError.connectivity
        let exp = expectation(description: "wait for load completion")
        
        
        sut.fetchVenueList { result in
            switch result{
            case .success(_):
                XCTFail("UnExpected Result")
            case let .failure(recievedError):
                XCTAssertEqual(recievedError as! NetworkError, expectedError)
            }
            exp.fulfill()
        }
        
        client.complete(with: expectedError, at: 0)
        wait(for: [exp], timeout: 1.0)
        
    }
    
    
    func test_load_deliversErrorOnNon200HTTPResponse(){
        let (sut,client) = makeSUT()
        let expectedError = NetworkError.invalidData
        
        let samples = [199,201,300,400,500]
        
        samples.enumerated().forEach { (index,code) in
            let exp = expectation(description: "wait for load completion")
            
            sut.fetchVenueList { result in
                switch result{
                case .success(_):
                    XCTFail("UnExpected Result")
                case let .failure(recievedError):
                    XCTAssertEqual(recievedError as! NetworkError, expectedError)
                }
                exp.fulfill()
            }
            
            client.complete(withStatusCode: code, withData: Data(), at: index)
            
            wait(for: [exp], timeout: 1.0)
        }
        
        
    }
    
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON(){
        let (sut,client) = makeSUT()
        let expectedError = NetworkError.invalidData
        let invalidJSON = Data("Invalid JSON".utf8)
        let exp = expectation(description: "wait for load completion")
        
        sut.fetchVenueList { result in
            switch result{
            case .success(_):
                XCTFail("UnExpected Result")
            case let .failure(recievedError):
                XCTAssertEqual(recievedError as! NetworkError, expectedError)
            }
            exp.fulfill()
        }
        
       
        client.complete(withStatusCode: 200, withData: invalidJSON, at: 0)
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyList(){
        let (sut,client) = makeSUT()
        let expectedError = NetworkError.invalidData
        let emptyData = makeItemsJSON(items: [])
        let exp = expectation(description: "wait for load completion")
        
        sut.fetchVenueList { result in
            switch result{
            case .success(_):
                XCTFail("UnExpected Result")
            case let .failure(recievedError):
                XCTAssertEqual(recievedError as! NetworkError, expectedError)
            }
            exp.fulfill()
        }
        
        client.complete(withStatusCode: 200, withData: emptyData, at: 0)
        wait(for: [exp], timeout: 1.0)
        
    }
    
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems(){
        let (sut,client) = makeSUT()
        let venue1 = makeItem(id: "1", name: "venue1", location: VenueLocation(address: "any address"))
        let venue2 = makeItem(id: "2", name: "venue2", location: VenueLocation(address: nil))
        let expectedResult = [venue1.model,venue2.model]
        let emptyData = makeItemsJSON(items: [venue1.json,venue2.json])
        let exp = expectation(description: "wait for load completion")
        
        sut.fetchVenueList { result in
            switch result{
            case let .success(recivedResult):
                XCTAssertEqual(expectedResult, recivedResult)
            case  .failure(_):
                XCTFail("UnExpected Result")
            }
            exp.fulfill()
        }
        
        client.complete(withStatusCode: 200, withData: emptyData, at: 0)
        wait(for: [exp], timeout: 1.0)
        
    }
    
    
    
    
    
    
    //MARK: - Helpers
    
    func makeSUT(urlRequest: URLRequest = URLRequest(url: URL(string: "www.any-url.com")!),_ file: StaticString = #filePath ,_ line: UInt = #line) -> (sut: RemoteVenueLoader,client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let cache = VenueResponseStorageSpy()
        let sut = RemoteVenueLoader(client: client, venueResponseStorage: cache, urlRequest: urlRequest)
        trackForMemoryLeaks(sut,file,line)
        trackForMemoryLeaks(client,file,line)
        trackForMemoryLeaks(cache,file,line)
        return (sut,client)
    }
    
    
    private func makeItem(id: String, name: String = "", location: VenueLocation = VenueLocation(address: nil)) -> (model: Venue, json:[String:Any]) {
        let item = Venue(id: id, name: name, location: location)
        let json = [
            "fsq_id" : item.id,
            "name" : item.name,
            "location" : ["address": item.location.address] ,
        ].compactMapValues{ $0 }
      
        return (item,json)
    }
    
    func makeItemsJSON(items : [[String:Any]]) -> Data {
        let itemsJSON = ["results" : items]
        let jsonData = try! JSONSerialization.data(withJSONObject: itemsJSON)
        return jsonData
    }
    
    
    func anyURLRequest() -> URLRequest {
        return URLRequest(url: URL(string: "www.any-url.com")!)
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    
    class HTTPClientSpy: HTTPClient{
        
        private var messages: [(urlRequest: URLRequest,completion: (HTTPClient.Result) -> () )] = []
        
        var requestedUrls :[URLRequest] {
            return messages.map{ $0.urlRequest }
        }
        
        func get(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> ()) {
            messages.append((request,completion))
        }
        
        func complete(with error: Error ,at index: Int = 0){
            self.messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode statusCode : Int,withData data : Data  ,at index : Int = 0){
            let urlResponse = HTTPURLResponse(url: requestedUrls[index].url!
                                              , statusCode: statusCode
                                              , httpVersion: nil
                                              , headerFields: nil)
            self.messages[index].completion(.success((data, urlResponse!)))
        }
        
    }
    
    
    class VenueResponseStorageSpy: VenueResponseStorage{
        func getResponse(completion: @escaping (Result<[Venue]?, CoreDataStorageError>) -> Void) {
            
        }
        
        func saveResponse(with venueList: [Venue]) {
            
        }
        
    }
    
}
