//
//  main.swift
//  Camlist
//
//  Created by SherifShokry on 23/11/2021.
//

import UIKit
//Fake App Delegate For Testing
let kIsRunningTests = NSClassFromString("XCTestCase") != nil
let kAppDelegateClass = kIsRunningTests ? nil : NSStringFromClass(AppDelegate.self)

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, kAppDelegateClass)
