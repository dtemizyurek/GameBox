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
    func showLoadingView()
    func hideLoadingView()
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
        self.delegate?.showLoadingView()
        apiRequest.getGamesDetails(id: String(gameModel.id)) { [weak self] result in
            DispatchQueue.main.async {
                self?.delegate?.hideLoadingView()
                switch result {
                case .success(let videoGameDetail):
                    let ratingString = String(format: "%.1f", videoGameDetail.rating)
                    let details = ("\(videoGameDetail.nameOriginal)\n\n" +
                                   " \(videoGameDetail.released)\n\n" +
                                   " \(ratingString)\n\n" +
                                   "\(videoGameDetail.welcomeDescription)").replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    self?.delegate?.didFetchGameDetails(details)
                case .failure(let error):
                    self?.delegate?.showError("Could not fetch the details: \(error.localizedDescription)")
                }
            }
        }
    }


    func fetchGameImage() {
        self.delegate?.showLoadingView()
        guard let imagePath = gameModel.backgroundImage else {
            self.delegate?.hideLoadingView()
            self.delegate?.showError("No image path available")
            return
        }
        
        apiRequest.getGameImage(path: imagePath) { [weak self] data, error in
            DispatchQueue.main.async {
                self?.delegate?.hideLoadingView()
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
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteVideoGames", in: context) else {
            delegate?.showError("Could not find entity description!")
            return
        }
        let newGame = NSManagedObject(entity: entity, insertInto: context)
        newGame.setValue(gameModel.id, forKey: "favoriteGameId")
        
        do {
            try context.save()
            print("Saved game with ID: \(gameModel.id)")
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
                print("Deleted game with ID: \(gameModel.id)")

            }
            try context.save()
        } catch {
            delegate?.showError("Could not be deleted!")
        }
    }
}
