//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by David Koch on 21.11.22.
//

import Foundation

struct SessionRequest: Codable{
    let udacity: User
    
}

struct User: Codable{
    var username: String
    var password: String
}
