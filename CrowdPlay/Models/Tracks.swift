//
//  Models.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/17/20.
//

import Foundation

struct CurrentlyPlayingResponse: Model, Codable {
    
    let item: Item
    
    
}


struct TracksResponse: Model, Codable {
    let tracks: Tracks?
}

struct RecentlyPlayedResponse: Model, Codable {
    let item: Item
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
    let album: Album
    
    
    
}

struct Album: Model, Codable {
    let images: [Image]
}

struct Image: Model, Codable {
    let height: Int
    let width: Int
    let url: URL
}

struct Artist: Model, Codable {
    let id: String
    let name: String
    let uri: String
    let type: String
}
