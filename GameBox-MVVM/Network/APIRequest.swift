//
//  APIRequest.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 21.05.2024.
//

import Foundation

public protocol APIRequestProtocol {
    func getGames(completion: @escaping (Result<[Game], Error>) -> Void)
    func getGameDetails(completion: @escaping (Result<[Game], Error>) -> Void)
}

public class APIRequest {
    
    static func getGames(page: Int, completion: @escaping ([GameResult], Error?) -> Void) {
        APIRequest.getRequestForGamesAndDetails(url: API.getGames(page).url, jsonType: Game.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    static func getGameDetails(id: String, completion: @escaping(GameDetail?,Error?) -> Void) {
        getRequestForGamesAndDetails(url: API.getGameDetails(id).url, jsonType: GameDetail.self) { response, error in
            if let response = response {
                completion(response,nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func getRequestForGamesAndDetails<JSONType: Decodable>(url: URL, jsonType: JSONType.Type, completion: @escaping (JSONType?, Error?) -> Void) {
        DispatchQueue.main.async(qos: .utility) {
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(JSONType.self, from: data)
                    completion(results, nil)
                } catch {
                    completion(nil, error)
                }
            }
            dataTask.resume()
        }
    }
}
