//
//  RemoteVenueImageLoader.swift
//  CamlistTests
//
//  Created by SherifShokry on 24/11/2021.
//

import Foundation
import XCTest
import Camlist

class RemoteVenueImageLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let (_,client) = makeSUT()

        XCTAssertEqual(client.requestedUrls, [])
    }

    func test_load_requestDataFromURL(){
        let urlRequest = anyURLRequest()
        let (sut,client) = makeSUT(urlRequest: urlRequest)

        sut.fetchVenueImage {_ in} completion: {_ in}

        XCTAssertEqual(client.requestedUrls, [urlRequest])
    }

    func test_loadImageTwice_LoadRequestTwice(){
        let urlRequest = anyURLRequest()
        let (sut,client) = makeSUT()

        sut.fetchVenueImage {_ in} completion: {_ in}
        sut.fetchVenueImage {_ in} completion: {_ in}

        XCTAssertEqual(client.requestedUrls, [urlRequest,urlRequest])
    }

    func test_load_deliversErrorWhenClientError(){
        let (sut,client) = makeSUT()
        let expectedError = NetworkError.connectivity
        let exp = expectation(description: "wait for load completion")

        sut.fetchVenueImage { cachedImage in
            
        } completion: { result in
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

        
            sut.fetchVenueImage(cached: {_ in}) { result in
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

        sut.fetchVenueImage(cached: {_ in}) { result in
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

        sut.fetchVenueImage(cached: {_ in}) { result in
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
        let venueImage1 = makeItem(id: "1", prefix: "www.any-", suffix: "image-url", width: 100, height: 100)
        let venueImage2 = makeItem(id: "2", prefix: "www.any-", suffix: "image-url2", width: 150, height: 150)
        let expectedResult = venueImage1.model
        let emptyData = makeItemsJSON(items: [venueImage1.json,venueImage2.json])
        let exp = expectation(description: "wait for load completion")

        
        sut.fetchVenueImage(cached: {_ in}) { result in
            switch result{
            case let .success(receivedResult):
                XCTAssertEqual(expectedResult, receivedResult)
            case  .failure(_):
                XCTFail("UnExpected Result")
            }
            exp.fulfill()
        }
    
        client.complete(withStatusCode: 200, withData: emptyData, at: 0)
        wait(for: [exp], timeout: 1.0)

    }

    
    
    
    
    
    //MARK: - Helpers
    
    func makeSUT(urlRequest: URLRequest = URLRequest(url: URL(string: "www.any-url.com")!),_ file: StaticString = #filePath ,_ line: UInt = #line) -> (sut: RemoteVenueImageLoader,client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let venueImageStorageMock = VenueImageStorageMock()
        let sut = RemoteVenueImageLoader(client: client, venueResponseStorage: venueImageStorageMock, urlRequest: urlRequest, venueId: "")
        trackForMemoryLeaks(sut,file,line)
        trackForMemoryLeaks(client,file,line)
        return (sut,client)
    }
    
  
    private func makeItem(id: String, prefix: String = "",suffix: String = "",width: Int = 100 ,height: Int = 100) -> (model: VenueImage, json:[String:Any]) {
        let item = VenueImage(id: id, prefix: prefix, suffix: suffix, width: width, height: height)
        let json = [
            "id" : item.id,
            "prefix" : item.prefix,
            "suffix" : item.suffix,
            "width"  : item.width,
            "height" : item.height
        ].compactMapValues{ $0 }

        return (item,json)
    }

    func makeItemsJSON(items : [[String:Any]]) -> Data {
        let itemsJSON = items
        
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
    
    class VenueImageStorageMock: VenueImageResponseStorage{
       
        func getResponse(with venueId: String, completion: @escaping (Result<VenueImage?, CoreDataStorageError>) -> Void) {
            completion(.success(VenueImage(id: "-1", prefix: "", suffix: "", width: 0, height: 0)))
        }
        
        func saveResponse(with venueImage: VenueImage, for venueId: String) {}
        
    }

}
