//
//  StudentGetResponse.swift
//  OnTheMap
//
//  Created by David Koch on 22.11.22.
//

import Foundation

struct StudentGetResponse: Codable{
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey{
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
