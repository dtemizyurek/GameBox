//
//  APIRequest.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 21.05.2024.
//

import Foundation

struct APIRequest {
    
    static func getGames(page: Int, completion: @escaping([GameResult],Error?) -> Void) {
        APIRequest.getGames(page: <#T##Int#>, completion: <#T##([GameResult], (any Error)?) -> Void#>)
    }
}
