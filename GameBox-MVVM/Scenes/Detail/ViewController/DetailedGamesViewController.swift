//
//  DetailedGamesViewController.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 25.05.2024.
//

import UIKit

final class DetailedGamesViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var relaseDate: UILabel!
    @IBOutlet weak var metaCriticPointLabel: UILabel!
    @IBOutlet weak var gameDescTextView: UITextView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var systemRequirmentsTextView: UITextView!
    //MARK: - Variables
    var viewModel: DetailedGamesViewModel!
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = 2
        blurEffectView.layer.masksToBounds = true
        return blurEffectView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        return gradientLayer
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        viewModel.fetchGameDetails()
        viewModel.fetchGameImage()
    }
    
    //MARK: - Private Functions
    private func setupUI() {
        gameTitleLabel.text = viewModel.gameModel.name
        setupBlurEffect()
        updateFavoriteButton()
    }
    
    private func setupBlurEffect() {
        gameImage.addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: gameImage.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: gameImage.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: gameImage.bottomAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: gameImage.heightAnchor, multiplier: 0.3)
        ])
        
        blurEffectView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = blurEffectView.bounds
    }
    
    private func updateFavoriteButton() {
        let buttonImage = (viewModel.gameModel.isFav ?? false) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        addFavoriteButton.setTitleColor((viewModel.gameModel.isFav ?? false) ? .systemOrange : .gray, for: .normal)
        addFavoriteButton.setImage(buttonImage, for: .normal)
    }
    
    //MARK: - Button action
    @IBAction func addFavoriteAction(_ sender: Any) {
        viewModel.toggleFavoriteStatus()
        print("Favorite button clicked for game: \(viewModel.gameModel.name ?? "Unknown")")
    }
}

//MARK: - Extesion ViewModelDelegate
extension DetailedGamesViewController: DetailedGamesViewModelDelegate {
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func didFetchGameDetails(_ details: String) {
        DispatchQueue.main.async {
            let detailComponents = details.split(separator: "\n", maxSplits: 3, omittingEmptySubsequences: true)
            if detailComponents.count > 1 {
                self.relaseDate.text = "\(detailComponents[1])"
            } else {
                self.relaseDate.text = "Release Date: N/A"
            }
            
            if detailComponents.count > 2 {
                self.metaCriticPointLabel.text = "\(detailComponents[2])"
            } else {
                self.metaCriticPointLabel.text = "Rating: N/A"
            }
            
            if detailComponents.count > 3 {
                self.gameDescTextView.text = String(detailComponents[3])
            } else {
                self.gameDescTextView.text = details
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

//MARK: - Extension LoadingShowable
extension DetailedGamesViewController: LoadingShowable {}
