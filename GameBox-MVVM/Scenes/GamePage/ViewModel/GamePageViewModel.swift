//
//  GamePageViewModel.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 25.05.2024.
//

import Foundation

protocol GamePageViewModelProtocol {
    var games: [GamesUIModel] { get }
    var onGamesUpdated: (() -> Void)? { get set }
    func fetchGames()
}

final class GamePageViewModel: GamePageViewModelProtocol {
    private(set) var games: [GamesUIModel] = [] {
        didSet {
            onGamesUpdated?()
        }
    }
    var onGamesUpdated: (() -> Void)?
    func fetchGames() {
        loadGamesFromAPI { [weak self] fetchedGames in
            self?.games = fetchedGames
        }
    }
    
    private func loadGamesFromAPI(completion: @escaping ([GamesUIModel]) -> Void) {}
}
