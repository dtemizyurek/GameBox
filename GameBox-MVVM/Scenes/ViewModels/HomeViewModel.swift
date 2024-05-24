//
//  HomeViewModel.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 23.05.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
    func showError(_ message: String)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var gameNames: [String] { get }
    func loadInitialGames(pageNumber: Int)
    func loadMoreGames()
    func game(index: IndexPath) -> GamesUIModel
}

final class HomeViewModel: HomeViewModelProtocol {
    let service: APIRequestProtocol
    private var games: [GameResults] = []
    weak var delegate: HomeViewModelDelegate?
    private var favouriteGameIDs = [Int]()
    private var currentPage: Int = 1
    private var isLoadingList: Bool = false

    init(service: APIRequestProtocol) {
        self.service = service
    }
    
    var numberOfItems: Int {
        return games.count
    }
    
    var gameNames: [String] {
        return games.compactMap { $0.name }
    }
    
    func loadInitialGames(pageNumber: Int) {
        currentPage = pageNumber
        games.removeAll()
        fetchGames(with: pageNumber)
    }
    
    func game(index: IndexPath) -> GamesUIModel {
           guard index.item < games.count else {
               return GamesUIModel(id: 0, rating: 0.0, released: "N/A", metacritic: 0, name: "N/A", backgroundImage: nil, isFav: false)
           }
           let gameResult = games[index.item]
           return GamesUIModel(
               id: gameResult.id ?? 0,
               rating: gameResult.rating ?? 0.0,
               released: gameResult.released ?? "N/A",
               metacritic: gameResult.metacritic ?? 0,
               name: gameResult.name ?? "N/A",
               backgroundImage: gameResult.backgroundImage,
               isFav: favouriteGameIDs.contains(gameResult.id ?? 0)
           )
       }
    
    private func fetchGames(with pageNumber: Int) {
        self.delegate?.showLoadingView()
        service.getGames(page: pageNumber) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleGameResponse(response)
                self.isLoadingList = false
            }
        }
    }

    private func handleGameResponse(_ response: Result<Game, Error>) {
        self.delegate?.hideLoadingView()
        switch response {
        case .success(let game):
            self.games.append(contentsOf: game.results ?? [])
            self.logGameNames()
            self.delegate?.reloadData()
        case .failure(let error):
            self.delegate?.showError("Failed to load games: \(error.localizedDescription)")
        }
    }
    
    private func logGameNames() {
        let names = gameNames.joined(separator: ", ")
        print("Fetched Games: \(names)")
    }
    
    func loadMoreGames() {
            guard !isLoadingList else {
                print("Already loading more games, returning early.")
                return
            }
            guard currentPage <= 500 else {
                print("Reached the maximum page limit, no more games to load.")
                return
            }
            
            isLoadingList = true
            currentPage += 1
            print("Loading more games, currentPage: \(currentPage)")
            fetchGames(with: currentPage)
        }
}
