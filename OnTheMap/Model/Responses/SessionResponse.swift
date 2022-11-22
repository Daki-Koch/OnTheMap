//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by David Koch on 21.11.22.
//

import Foundation

struct SessionResponse: Codable{
    let account: Account
    let session: Session
    
    struct Account: Codable{
        let registered: Bool
        let key: String
    }
    
    struct Session: Codable{
        let id: String
        let expiration: String
    }
}

struct SessionErrorResponse: Codable{
    var status: Int
    var error: String
}

extension SessionErrorResponse: LocalizedError{
    var errorDescription: String?{
        return error
    }
}
