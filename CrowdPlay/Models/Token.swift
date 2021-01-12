//
//  Token.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 1/9/21.
//

import Foundation

struct Token: Model, Codable {
    
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String
    
    
}


struct Code: Model, Codable {
    let code: String
    let state: String
    
}



