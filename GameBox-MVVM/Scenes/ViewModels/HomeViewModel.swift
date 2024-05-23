//
//  HomeViewModel.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 23.05.2024.
//

import Foundation

extension HomeViewModel {
    
    fileprivate enum Constants {
        static let cellTitleHeight: CGFloat = 50
        static let cellPosterImageRatio: CGFloat = 1 / 2
        static let cellLeftPadding: CGFloat = 16
        static let cellRightPadding: CGFloat = 16
    }
}

protocol HomeViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var cellPadding: Double { get }
    func load()
    //func didSelect()
    func game(index: IndexPath) -> GamesUIModel
    func calculateCellHeight(collectionViewWidth: Double) -> Double
}

final class HomeViewModel: HomeViewModelProtocol {
    let service: APIRequestProtocol
    private var games: [GameResults] = []
    weak var delegate: HomeViewModelDelegate?
    
    init(service: APIRequestProtocol) {
        self.service = service
    }
    
    var numberOfItems: Int {
        return games.count
    }
    
    var cellPadding: Double {
        return Double(Constants.cellLeftPadding + Constants.cellRightPadding)
    }
    
    func load() {
        fetchGames()
    }
    
    func game(index: IndexPath) -> GamesUIModel {
        let gameResult = games[index.item]
        return GamesUIModel(
            id: gameResult.id ?? 0,
            rating: gameResult.rating,
            released: gameResult.released,
            metacritic: gameResult.metacritic,
            name: gameResult.name,
            backgroundImage: gameResult.backgroundImage,
            isFav: false 
        )
    }
    
    func calculateCellHeight(collectionViewWidth: Double) -> Double {
        let posterImageHeight = (collectionViewWidth - cellPadding) * Double(Constants.cellPosterImageRatio)
        return posterImageHeight + Double(Constants.cellTitleHeight)
    }
    
    private func fetchGames() {
        self.delegate?.showLoadingView()
        service.getGames(page: 1) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.hideLoadingView()
                switch response {
                case .success(let game):
                    self.games = game.results ?? []
                    self.delegate?.reloadData()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

