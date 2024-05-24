//
//  GamePageViewModel.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 24.05.2024.
//

import Foundation

protocol GamePageViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didFailWithError(_ error: Error)
}

class GamePageViewModel {
    var gameSource: [GamesUIModel] = []
    weak var delegate: GamePageViewModelDelegate?
    private var timer: Timer?
    private var currentIndex: Int = 0
    
    var numberOfItems: Int {
        return gameSource.count
    }
    
    func game(at index: Int) -> GamesUIModel? {
        guard index >= 0 && index < gameSource.count else { return nil }
        return gameSource[index]
    }
    
    func populateGames(with games: [GamesUIModel]) {
        self.gameSource = games
        delegate?.didUpdateGames()
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }
    
    @objc private func changeImage() {
        goToNextPage()
    }
    
    private func goToNextPage() {
        currentIndex = (currentIndex + 1) % gameSource.count
        delegate?.didUpdateGames()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

