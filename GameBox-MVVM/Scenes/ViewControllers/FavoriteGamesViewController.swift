//
//  FavoriteGamesViewController.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 26.05.2024.
//

import UIKit

final class FavoriteGamesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: FavoriteGamesViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupViewModel()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewModel?.loadFavoriteGames()
        }
        
        private func setupUI() {
            collectionView.delegate = self
            collectionView.dataSource = self
            searchBar.delegate = self
            collectionView.register(UINib(nibName: "GamesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GamesCollectionViewCell")
        }
        
        private func setupViewModel() {
            viewModel = FavoriteGamesViewModel()
            viewModel?.delegate = self
        }
    }

    // MARK: - FavoriteGamesViewModelDelegate
    extension FavoriteGamesViewController: FavoriteGamesViewModelDelegate {
        func reloadData() {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
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

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    extension FavoriteGamesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel?.numberOfItems ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamesCollectionViewCell", for: indexPath) as? GamesCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let game = viewModel?.game(at: indexPath) else { return .init() }
            cell.configure(games: game)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = self.view.frame.size.width
            return CGSize(width: width / 2, height: 250)
        }
    }

    // MARK: - UISearchBarDelegate
    extension FavoriteGamesViewController: UISearchBarDelegate {
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel?.filterGames(with: searchText)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            viewModel?.filterGames(with: "")
        }
    }
