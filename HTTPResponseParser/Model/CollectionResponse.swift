//
//  CollectionResponse.swift
//  HTTPResponseParser
//
//  Created by Nikita Levintsov on 5/9/19.
//  Copyright © 2019 tovnixon. All rights reserved.
//

import Foundation

/// Dummy collection struct to demonstrate Parser functionality
struct UserGroup: Codable {

    let users: [User]
}

