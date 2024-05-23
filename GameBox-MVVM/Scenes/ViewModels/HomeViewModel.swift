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
        static let cellPosterImageRatio: CGFloat = 1/2
        static let cellLeftPadding: CGFloat = 16
        static let cellRightPadding: CGFloat = 16
        
    }
}

protocol HomeViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLodingView()
    func reloadData()
    
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var cellPadding: Double { get }
    func load()
    func movie(index: IndexPath) -> GamesUIModel
    func calculateCellHeight(collectionViewWidth: Double) -> Double
}

final class HomeViewModel {
    let service: APIRequestProtocol
    var games = [GamesUIModel]()
    weak var delegate: HomeViewModelDelegate?
    
    init(service: APIRequestProtocol, games: [GamesUIModel] = [GamesUIModel](), delegate: HomeViewModelDelegate? = nil) {
        self.service = service
    }
    
}

