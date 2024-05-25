//
//  DetailedGamesViewController.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 25.05.2024.
//

import UIKit

final class DetailedGamesViewController: UIViewController {
    @IBOutlet weak var relaseDate: UILabel!
    @IBOutlet weak var metaCriticPointLabel: UILabel!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    var viewModel: DetailedGamesViewModel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            viewModel.delegate = self
            viewModel.fetchGameDetails()
            viewModel.fetchGameImage()
        }
        
        private func setupUI() {
            gameTitleLabel.text = viewModel.gameModel.name
            updateFavoriteButton()
        }
        
        private func updateFavoriteButton() {
            let buttonTitle = (viewModel.gameModel.isFav ?? false) ? "Remove from Favorites" : "Add to Favorites"
            addFavoriteButton.setTitle(buttonTitle, for: .normal)
            addFavoriteButton.setTitleColor((viewModel.gameModel.isFav ?? false) ? .systemOrange : .gray, for: .normal)
        }
        
        @IBAction func addFavoriteAction(_ sender: Any) {
            viewModel.toggleFavoriteStatus()
        }
    }

    extension DetailedGamesViewController: DetailedGamesViewModelDelegate {
        func didFetchGameDetails(_ details: String) {
            DispatchQueue.main.async {
                let detailComponents = details.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: true)
                if detailComponents.count >= 3 {
                    self.relaseDate.text = "Release Date: \(detailComponents[1])"
                    self.metaCriticPointLabel.text = "Metacritic: \(detailComponents[2])"
                    self.gameDescriptionLabel.text = String(detailComponents[3])
                } else {
                    self.gameDescriptionLabel.text = details
                }
            }
        }
        
        func didFetchGameImage(_ data: Data?) {
            DispatchQueue.main.async {
                if let data = data {
                    self.gameImage.image = UIImage(data: data)
                } else {
                    self.gameImage.image = UIImage(named: "PosterPlaceholder")
                }
            }
        }
        
        func didUpdateFavoriteStatus(isFav: Bool) {
            DispatchQueue.main.async {
                self.updateFavoriteButton()
            }
        }
        
        func showError(_ message: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
