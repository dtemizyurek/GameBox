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
    func showError(_ message: String)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var cellPadding: Double { get }
    func load(pageNumber: Int)
    //    func didSelect()
    func loadMoreGames()
    func game(index: IndexPath) -> GamesUIModel
    func calculateCellHeight(collectionViewWidth: Double) -> Double
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
    
    var cellPadding: Double {
        return Double(Constants.cellLeftPadding + Constants.cellRightPadding)
    }
    
    func load(pageNumber: Int) {
        fetchGames(with: pageNumber)
        loadMoreGames()
    }
    
    func game(index: IndexPath) -> GamesUIModel {
        guard index.item < games.count else {
            return GamesUIModel(id: 0, rating: 0, released: "", metacritic: 0, name: "", backgroundImage: "", isFav: false)
        }
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
    
    private func fetchGames(with pageNumber: Int) {
        self.delegate?.showLoadingView()
        service.getGames(page: pageNumber) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleGameResponse(response)
            }
        }
    }

    private func handleGameResponse(_ response: Result<Game, Error>) {
        self.delegate?.hideLoadingView()
        switch response {
        case .success(let game):
            self.games.append(contentsOf: game.results ?? [])
            self.delegate?.reloadData()
        case .failure(let error):
            self.delegate?.showError("Failed to load games: \(error.localizedDescription)")
        }
    }
    
    func loadMoreGames() {
        guard !isLoadingList && currentPage <= 500 else { return }
        isLoadingList = true
        currentPage += 1
        fetchGames(with: currentPage)
    }
    
}

