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
    func showError(_ message: String)
}

final class FavoriteGamesViewModel {
    weak var delegate: FavoriteGamesViewModelDelegate?
    private(set) var filteredVideoGames = [GamesUIModel]()
    private(set) var isFiltering: Bool = false
    private var dataSource = [GamesUIModel]()
    private var gamesSource = [GamesUIModel]()
    private var favouriteGameIDS = [Int]()
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
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
        guard !gamesSource.isEmpty else { return }
        dataSource = gamesSource.filter { favouriteGameIDS.contains($0.id) }
        DispatchQueue.main.async {
            self.delegate?.reloadData()
        }
    }
    
    func updateFavGames(games: [GamesUIModel]) {
        gamesSource = games
        checkFavoriteUpdates()
    }

    func filterGames(with searchText: String) {
        if searchText.isEmpty || searchText.count <= 3 {
            isFiltering = false
        } else {
            isFiltering = true
            filteredVideoGames = dataSource.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        DispatchQueue.main.async {
            self.delegate?.reloadData()
        }
    }
    
    
    var numberOfItems: Int {
        return isFiltering ? filteredVideoGames.count : dataSource.count
    }
    
    func game(at indexPath: IndexPath) -> GamesUIModel {
        return isFiltering ? filteredVideoGames[indexPath.item] : dataSource[indexPath.item]
    }
}
