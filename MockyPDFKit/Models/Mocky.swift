//
//  Mocky.swift
//  MockyPDFKit
//
//  Created by Yefga on 31/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import Foundation

struct Mocky: Decodable, Hashable {
    
    let status: Int
    let data: [Item]
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
    }
}

struct Item: Decodable, Hashable {
    let name, file: String
    
    enum CodingKeys: String, CodingKey {
        case name, file
    }
}
