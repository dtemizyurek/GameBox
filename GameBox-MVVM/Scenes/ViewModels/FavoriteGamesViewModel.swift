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
    private(set) var filteredVideoGames = [GameDetail]()
    private(set) var isFiltering: Bool = false
    private var dataSource = [GameDetail]()
    private var gamesSource = [GameDetail]()
    private var favouriteGameIDS = [Int]()
    private let apiRequest: APIRequestProtocol
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = CoreDataManager.shared,apiRequest: APIRequestProtocol = APIRequest()) {
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
        self.gamesSource.removeAll()
        self.filteredVideoGames.removeAll()
        self.dataSource.removeAll()
        let queue = DispatchQueue(label: "checkFavoriteUpdates", qos: .background,attributes: .concurrent )
        let group = DispatchGroup()
        favouriteGameIDS.forEach { id in
            group.enter()
            queue.async {
                self.apiRequest.getGamesDetails(id: "\(id)") { result in
                    switch result {
                    case .success(let success):
                        self.gamesSource.append(success)
                        group.leave()
                    case .failure(let failure):
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: queue) {
            guard !self.gamesSource.isEmpty else { return }
            //dataSource = gamesSource.filter { favouriteGameIDS.contains($0.id) }
            DispatchQueue.main.async {
                self.delegate?.reloadData()
            }
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
}
