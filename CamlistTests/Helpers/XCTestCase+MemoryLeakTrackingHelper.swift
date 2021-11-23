//
//  XCTestCase+MemoryLeakTrackingHelper.swift
//  CamlistTests
//
//  Created by SherifShokry on 22/11/2021.
//

import Foundation
import XCTest


extension XCTestCase {
    
     func trackForMemoryLeaks(_ instance: AnyObject,_ file: StaticString = #filePath ,_ line: UInt = #line){
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance,"Instance should have been deallocated , Potential memory leak",file: file , line: line)
        }
    }
    
}
