//
//  HTTPResponseParserTests.swift
//  HTTPResponseParserTests
//
//  Created by Nikita Levintsov on 5/10/19.
//  Copyright © 2019 tovnixon. All rights reserved.
//

import XCTest
@testable import HTTPResponseParser

class HTTPResponseParserTests: XCTestCase {
    
    var parser: Parser!
    
    override func setUp() {
        parser = Parser()
    }

    private func getData(from file: String) -> Data? {
        let testBundle = Bundle(for: HTTPResponseParserTests.self)
        guard let path = testBundle.path(forResource: file, ofType: "json") else {
            return nil
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }

    override func tearDown() {
        self.parser = nil
    }

    func testParseValidObject() {
        let data = getData(from: "DefaultObjectResponse")
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success(let object):
            XCTAssert(object != nil, "Nil produced from the valid JSON")
        case .failure(let error):
            XCTFail("Error \(error) produced from the valid JSON")
        }
    }
    
    func testParseValidCollection() {
        let data = getData(from: "DefaultCollectionResponse")
        let result = parser.getPayload(from: data, of: UserGroup.self)
        
        switch result {
        case .success(let object):
            XCTAssert(object != nil, "Nil produced from the valid JSON")
        case .failure(let error):
            XCTFail("Error \(error) produced from the valid JSON")
        }
    }

    func testParseSuccessResultWithEmptyPayload() {
        let data = getData(from: "SuccesResultWithEmptyPayload")
        let result = parser.getPayload(from: data, of: UserGroup.self)
        
        switch result {
        case .success(let object):
            XCTAssert(object == nil, "Object produced from the empty payload")
        case .failure(let error):
            XCTFail("Error \(error) produced from the valid JSON")
        }
    }
    
    func testParseValidObjectResultInt() {
        let data = getData(from: "DefaultObjectResponseResultInt")
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success(let object):
            XCTAssert(object != nil, "Failed to parse 'result' as an integer")
        case .failure(let error):
            switch error {
            case .invalidData:
            break // as expected
            case .operationFailed( _), .noData:
                XCTFail("Incorrect error type")
            }
        }
    }
    
    func testParseValidObjectResultUnexpectedInt() {
        let data = getData(from: "DefaultObjectResponseResultUnexpectedInt")
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success( _):
            XCTFail("Produced object from operation with unknown result")
        case .failure(let error):
            switch error {
            case .invalidData:
            break // as expected
            case .operationFailed( _), .noData:
                XCTFail("Incorrect error type")
            }
        }
    }
    
    
    func testParseValidObjectResultString() {
        let data = getData(from: "DefaultObjectResponseResultString")
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success(let object):
            XCTAssert(object != nil, "Failed to parse 'result' as a string")
        case .failure(let error):
            switch error {
            case .invalidData:
            break // as expected
            case .operationFailed( _), .noData:
                XCTFail("Incorrect error type")
            }
            
        }
    }
    
    func testParseValidObjectResultUnexpectedString() {
        let data = getData(from: "DefaultObjectResponseResultUnexpectedString")
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success( _):
            XCTFail("Produced object from operation with unknown result")
        case .failure(let error):
            switch error {
            case .invalidData:
            break // as expected
            case .operationFailed( _), .noData:
                XCTFail("Incorrect error type")
            }
        }
    }
    
    func testParseValidObjectResultIntAsString() {
        let data = getData(from: "DefaultObjectResponseResultIntAsString")
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success(let object):
            XCTAssert(object == nil, "Payload produced ignoring result of the operation")
        case .failure(let error):
            let assertMessage = "Incorrect error type, \(ParseError.operationFailed(reason: ErrorDescriprion.unknown.rawValue)) expected"
            switch error {
            case .invalidData, .noData:
                XCTFail(assertMessage)
            case .operationFailed(let reason):
                XCTAssert(reason == ErrorDescriprion.unknown.rawValue, assertMessage)
            }
        }
    }
    
    func testParseErrorObject() {
        let data = getData(from: "DefaultObjectResponseError")
        let result = parser.getPayload(from: data, of: User.self)
        let expectedError = "User was removed"
        let assertMessage = "Incorrect error type, \(expectedError) expected"
        
        switch result {
        case .success(let object):
            XCTAssert(object == nil, "Value produced from the JSON without payload")
        case .failure(let error):
            switch error {
            case .invalidData, .noData:
                XCTFail(assertMessage)
            case .operationFailed(let reason):
                XCTAssert(reason == expectedError, assertMessage)
            }
        }
    }
    
    func testParseErrorAsStringObject() {
        let data = getData(from: "DefaultObjectResponseErrorResultString")
        let result = parser.getPayload(from: data, of: User.self)
        let expectedError = "User was removed"
        let assertMessage = "Incorrect error type, \(expectedError) expected"
        
        switch result {
        case .success(let object):
            XCTAssert(object == nil, "Value produced from the JSON without payload")
        case .failure(let error):
            switch error {
            case .invalidData, .noData:
                XCTFail(assertMessage)
            case .operationFailed(let reason):
                XCTAssert(reason == expectedError, assertMessage)
            }
        }
    }
    
    func testParseRandomData() {
        let data = Data(capacity: 8)
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success( _):
            XCTFail("Value produced from random bytes")
        case .failure(let error):
            switch error {
            case .invalidData:
                // as expected
                break
            case .operationFailed( _), .noData:
                XCTFail("Invalid error type")
            }
        }
    }
    
    func testParseUnexpectedObject() {
        let data = getData(from: "UnexpectedObjectResponse")
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success( _):
            XCTFail("Object produced from the unexpected JSON")
        case .failure(let error):
            switch error {
            case .invalidData:
                // as expected
                break
            case .operationFailed( _), .noData:
                XCTFail("Invalid error type")
            }
        }
    }
    
    func testEmptyJSON() {
        let data = getData(from: "Empty")
        let result = parser.getPayload(from: data, of: User.self)
        
        switch result {
        case .success( _):
            XCTFail("Object produced from the empty JSON")
        case .failure(let error):
            switch error {
            case .invalidData:
                // as expected
                break
            case .operationFailed( _), .noData:
                XCTFail("Invalid error type")
            }
        }
    }
}
