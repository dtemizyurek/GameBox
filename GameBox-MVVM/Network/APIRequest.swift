//
//  APIRequest.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 21.05.2024.
//

import Foundation

protocol APIRequestProtocol {
    func getGames(page: Int, completion: @escaping (Result<Game, Error>) -> Void)
    func getGamesDetails(id: String, completion: @escaping (Result<GameDetail, Error>) -> Void)
}

final class APIRequest: APIRequestProtocol {
    
    func getGames(page: Int, completion: @escaping (Result<Game, Error>) -> Void) {
        APIRequest.getRequestForGamesAndDetails(url: API.getGames(page).url, jsonType: Game.self) { result in
            completion(result)
        }
    }
    
    func getGamesDetails(id: String, completion: @escaping (Result<GameDetail, Error>) -> Void) {
        APIRequest.getRequestForGamesAndDetails(url: API.getGameDetails(id).url, jsonType: GameDetail.self) { result in
            completion(result)
        }
    }
    
    private static func getRequestForGamesAndDetails<T: Decodable>(url: URL, jsonType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        print("API Request URL: \(url)") 
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API Request Error: \(error.localizedDescription)") // Log the error
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "YourAppErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("API Request Error: No data received")
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                print("API Request Success: Data decoded successfully") // Log successful decoding
                completion(.success(decodedData))
            } catch {
                print("API Request Error: \(error.localizedDescription)") // Log the decoding error
                completion(.failure(error))
            }
        }.resume()
    }
}

enum APIError: Error {
    case unknown
}

