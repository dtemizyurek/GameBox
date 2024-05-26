//
//  FavoriteGamesViewModel.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 25.05.2024.
//
import Foundation
import CoreData

protocol FavoriteGamesViewModelDelegate: AnyObject {
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
    func showError(_ message: String)
    func navigateToGameDetails(with gameModel: GamesUIModel)
}

protocol FavoriteGameViewModelProtocol {
    var delegate: FavoriteGamesViewModelDelegate? { get set }
    func selectGame(at indexPath: IndexPath)
    func loadFavoriteGames()
    func updateFavGames(games: [GameDetail])
    func filterGames(with searchText: String)
    var numberOfItems: Int { get }
    func game(at indexPath: IndexPath) -> GameDetail
}

final class FavoriteGamesViewModel: FavoriteGameViewModelProtocol {
    weak var delegate: FavoriteGamesViewModelDelegate?
    private(set) var filteredVideoGames = [GameDetail]()
    private(set) var isFiltering: Bool = false
    private var dataSource = [GameDetail]()
    private var gamesSource = [GameDetail]()
    private var favouriteGameIDS = [Int]()
    private let apiRequest: APIRequestProtocol
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared, apiRequest: APIRequestProtocol = APIRequest()) {
        self.coreDataManager = coreDataManager
        self.apiRequest = apiRequest
    }
    
    func loadFavoriteGames() {
        favouriteGameIDS.removeAll()
        let context = coreDataManager.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteVideoGames")
        
        context.perform {
            do {
                let results = try context.fetch(fetchRequest)
                if let results = results as? [NSManagedObject] {
                    for result in results {
                        if let favoriteGameId = result.value(forKey: "favoriteGameId") as? Int {
                            self.favouriteGameIDS.append(favoriteGameId)
                        }
                    }
                    self.checkFavoriteUpdates()
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.showError("Error fetching favorite games")
                }
            }
        }
    }
    
    private func checkFavoriteUpdates() {
        delegate?.showLoadingView()
        self.gamesSource.removeAll()
        self.filteredVideoGames.removeAll()
        self.dataSource.removeAll()
        
        let group = DispatchGroup()
        
        for id in favouriteGameIDS {
            group.enter()
            apiRequest.getGamesDetails(id: "\(id)") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        self.gamesSource.append(success)
                    case .failure(let error):
                        print("Error fetching game details for id \(id): \(error)")
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.delegate?.hideLoadingView()
            guard !self.gamesSource.isEmpty else { return }
            self.dataSource = self.gamesSource
            self.delegate?.reloadData()
        }
    }
    
    func updateFavGames(games: [GameDetail]) {
        gamesSource = games
        checkFavoriteUpdates()
    }
    
    func filterGames(with searchText: String) {
        if searchText.isEmpty || searchText.count <= 3 {
            isFiltering = false
        } else {
            isFiltering = true
            filteredVideoGames = dataSource.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        DispatchQueue.main.async {
            self.delegate?.reloadData()
        }
    }
    
    var numberOfItems: Int {
        return isFiltering ? filteredVideoGames.count : gamesSource.count
    }
    
    func game(at indexPath: IndexPath) -> GameDetail {
        return isFiltering ? filteredVideoGames[indexPath.item] : gamesSource[indexPath.item]
    }
    
    func selectGame(at indexPath: IndexPath) {
        let selectedGame = game(at: indexPath)
        let uiModel = GamesUIModel(
            id: selectedGame.id,
            rating: selectedGame.rating,
            released: selectedGame.released,
            metacritic: selectedGame.metacritic,
            name: selectedGame.name,
            backgroundImage: selectedGame.backgroundImage,
            isFav: true // Assume that all games here are favorite
        )
        delegate?.navigateToGameDetails(with: uiModel)
    }
}
