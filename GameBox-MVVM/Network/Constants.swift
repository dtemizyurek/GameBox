//
//  Constants.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 20.05.2024.
//

import Foundation

enum Constants {
    
    static let apiKey = "43ecda5a2b1047dbb846a5806ff195b8"
    static let base = "https://api.rawg.io/api"
    static let apiKeyParameter = "?key=\(apiKey)"
    
    case getGames(Int)
    case getGameDetails(String)
    case getGameImage(String)
    
    var url: URL {
        switch self {
        case .getGameDetails(let page): return URL(string: Constants.base + "/games" + Constants.apiKeyParameter + "&page=\(page)")!
        case .getGames(let id): return URL(string: Constants.base + "/games/\(id)" + Constants.apiKeyParameter)!
        case .getGameImage(let backgroundImagePath):
            return URL(string: backgroundImagePath)!
        }
    }
}
