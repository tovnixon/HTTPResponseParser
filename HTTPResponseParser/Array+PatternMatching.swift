//
//  Array+PatternMatching.swift
//  HTTPResponseParser
//
//  Created by Nikita Levintsov on 5/10/19.
//  Copyright © 2019 tovnixon. All rights reserved.
//

import Foundation

func ~=<T : Equatable>(array: [T], value: T) -> Bool {
    return array.contains(value)
}
