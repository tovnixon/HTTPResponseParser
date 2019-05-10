//
//  Parser.swift
//  HTTPResponseParser
//
//  Created by Nikita Levintsov on 5/9/19.
//  Copyright © 2019 tovnixon. All rights reserved.
//

import Foundation

public enum ParseError: Error {
    /// data is nil
    case noData
    
    /// data is not in expected JSON format or not JSON at all
    case invalidData
    
    /// data is valid but logically operation failed
    case operationFailed(reason: String)
}

public final class Parser {
    
    /// Returns object of type T in case of succes or ParseError in case of failure
    ///
    /// - Parameters:
    ///   - data: JSON data
    ///   - type: type of object expected in the 'payload' container of the JSON
    func getPayload<T: Codable>(from data: Data?, of type: T.Type) -> Result<T?, ParseError> {
        guard let data = data else {
            return .failure(.noData)
        }
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(HTTPResponse<T>.self, from: data)
            if response.result == true {
                return .success(response.payload)
            } else {
                let reason = response.message ?? ErrorDescriprion.unknown.rawValue
                return .failure(.operationFailed(reason: reason))
            }
        } catch {
            return .failure(.invalidData)
        }
    }
}
