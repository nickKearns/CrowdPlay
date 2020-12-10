//
//  Tracks.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/17/20.
//

import Foundation


struct TracksResponse: Model, Codable {
    let tracks: Tracks?
    
    
    
}

struct Tracks: Model, Codable {
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}


struct Item: Model, Codable {
    
    let name: String
    let id: String
    let uri: String
    let artists: [Artist]
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case uri
        case artists
        
    }
    
}

struct Artist: Model, Codable {
    let id: String
    let name: String
    let uri: String
    let type: String
}
