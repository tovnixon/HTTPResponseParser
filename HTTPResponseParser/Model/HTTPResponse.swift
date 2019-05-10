//
//  HTTPResponse.swift
//  HTTPResponseParser
//
//  Created by Nikita Levintsov on 5/9/19.
//  Copyright © 2019 tovnixon. All rights reserved.
//

import Foundation

/// Decodes JSON with following structure
/// {
///     "result": Bool,
///     "message": String,
///     "payload": {} - Object or Collection
/// }

struct HTTPResponse<T>: Decodable where T: Decodable {

    /// int result range which will be treated as true
    private let acceptableTrueInt = 1...1
    
    /// int result range which will be treated as false
    private let acceptableFalseInt = 0...0
    
    /// string result range which will be treated as true
    private let acceptableTrueStrings = ["true", "1"]
    
    /// string result range which will be treated as false
    private let acceptableFalseStrings = ["false", "0"]
    
    enum DecodeError: Error {
        /// imposible to know for sure whether result meant to be true or false
        case unexpectedResultType
    }

    private enum CodingKeys: String, CodingKey {
        
        case result = "result"
        
        case message = "message"
        
        case payload = "payload"
    }
    
    /// indicates succes or fail of the operation
    var result: Bool
    
    /// presented if operation failed and holds explanation
    var message: String?
    
    /// arbitrary container depending on the nature of the operation
    var payload: T?
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Tolerate result type as Bool
        do {
            self.result = try container.decode(Bool.self, forKey: .result)
        } catch {
            do {
                // or Int
                let resultInt = try container.decode(Int.self, forKey: .result)
                if acceptableTrueInt ~= resultInt {
                    self.result = true
                } else if acceptableFalseInt ~= resultInt {
                 self.result = false
                } else {
                    throw DecodeError.unexpectedResultType
                }
            } catch {
                do {
                    // or String
                    let resultString = try container.decode(String.self, forKey: .result).lowercased()
                    if acceptableTrueStrings.contains(resultString) {
                        self.result = true
                    } else if acceptableFalseStrings.contains(resultString) {
                        self.result = false
                    } else {
                        throw DecodeError.unexpectedResultType
                    }
                } catch {
                    throw DecodeError.unexpectedResultType
                }
            }
        }
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.payload = try container.decodeIfPresent(T.self, forKey: .payload)
    }
}

