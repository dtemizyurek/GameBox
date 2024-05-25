//
//  DetailedGamesViewModel.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 25.05.2024.
//

// DetailedGamesViewModel.swift
import Foundation
import CoreData

protocol DetailedGamesViewModelDelegate: AnyObject {
    func didFetchGameDetails(_ details: String)
    func didFetchGameImage(_ data: Data?)
    func didUpdateFavoriteStatus(isFav: Bool)
    func showError(_ message: String)
}

class DetailedGamesViewModel {
    weak var delegate: DetailedGamesViewModelDelegate?
    var gameModel: GamesUIModel
    private let apiRequest: APIRequestProtocol
    private let coreDataManager: CoreDataManager

    init(gameModel: GamesUIModel, apiRequest: APIRequestProtocol = APIRequest(), coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.gameModel = gameModel
        self.apiRequest = apiRequest
        self.coreDataManager = coreDataManager
    }

    func fetchGameDetails() {
        apiRequest.getGamesDetails(id: String(gameModel.id)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let videoGameDetail):
                    let details = ("\(videoGameDetail.nameOriginal)\n\n" +
                                   "Release Date: \(videoGameDetail.released)\n" +
                                   "Metacritic Rate: \(videoGameDetail.metacritic)\n\n" +
                                   "\(videoGameDetail.welcomeDescription)").replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    self?.delegate?.didFetchGameDetails(details)
                case .failure(let error):
                    self?.delegate?.showError("Could not fetch the details: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchGameImage() {
        guard let imagePath = gameModel.backgroundImage else {
            delegate?.showError("No image path available")
            return
        }
        
        apiRequest.getGameImage(path: imagePath) { [weak self] data, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.delegate?.showError("Could not fetch the image: \(error.localizedDescription)")
                    return
                }
                self?.delegate?.didFetchGameImage(data)
            }
        }
    }

    func toggleFavoriteStatus() {
        DispatchQueue.main.async { [weak self] in
            if self?.gameModel.isFav == true {
                self?.removeFromFavorites()
            } else {
                self?.addToFavorites()
            }
            self?.gameModel.isFav?.toggle()
            self?.delegate?.didUpdateFavoriteStatus(isFav: self?.gameModel.isFav ?? false)
        }
    }

    private func addToFavorites() {
        let context = coreDataManager.context
        let newGame = NSEntityDescription.insertNewObject(forEntityName: "FavoriteVideoGames", into: context)
        newGame.setValue(gameModel.id, forKey: "favoriteGameId")
        
        do {
            try context.save()
        } catch {
            delegate?.showError("Could not be saved!")
        }
    }

    private func removeFromFavorites() {
        let context = coreDataManager.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteVideoGames")
        
        fetchRequest.predicate = NSPredicate(format: "favoriteGameId = %@", "\(gameModel.id)")
        do {
            let fetchedResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            for entity in fetchedResults! {
                context.delete(entity)
            }
            try context.save()
        } catch {
            delegate?.showError("Could not be deleted!")
        }
    }
}

