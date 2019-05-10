//
//  EmailReponse.swift
//  HTTPResponseParser
//
//  Created by Nikita Levintsov on 5/9/19.
//  Copyright © 2019 tovnixon. All rights reserved.
//

import Foundation

/// Dummy object struct to demonstrate Parser functionality
struct User: Codable {
    
    let name: String
    
    let isAvailable: Bool
    
    let lastActivity: Double
}
