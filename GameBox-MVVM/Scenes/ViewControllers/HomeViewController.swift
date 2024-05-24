//
//  ViewController.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 17.05.2024.
//

import UIKit

final class HomeViewController: UIViewController  {
    //MARK: - IBOutlets
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollPageView: UIView!
    
    var viewModel: HomeViewModelProtocol? {
          didSet {
              viewModel?.delegate = self
          }
      }
      
      // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupCollectionView()
        loadInitialData()
    }
    
      // MARK: - Private Methods
      private func setupViewModel() {
          if viewModel == nil {
              let service = APIRequest()
              viewModel = HomeViewModel(service: service)
          }
      }
      
      private func setupCollectionView() {
          collectionView.dataSource = self
          collectionView.delegate = self
          collectionView.register(cellType: GamesCollectionViewCell.self)
      }
      
    
    private func loadInitialData() {
        guard let viewModel = viewModel else {
            print("viewModel is not set")
            return
        }
        viewModel.loadInitialGames(pageNumber: 1)
    }
    
    private func logGameNames() {
         if let gameNames = viewModel?.gameNames {
             print("Fetched Games: \(gameNames)")
         }
     }
  }

  // MARK: - UICollectionViewDataSource
  extension HomeViewController: ConfigureCollectionView {
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return viewModel?.numberOfItems ?? 0
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeCell(cellType: GamesCollectionViewCell.self, indexPath: indexPath)
          if let game = viewModel?.game(index: indexPath) {
              cell.configure(games: game)
          }
          return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let cellWidth: CGFloat = collectionView.frame.width - 40
          let cellHeight: CGFloat = 130
          
          return CGSize(width: cellWidth, height: cellHeight)
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          .init(
              top: 10,
              left: 10,
              bottom: 10,
              right: 16
          )
      }

}

extension HomeViewController: HomeViewModelDelegate {
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showError(_ message: String) {
        UIAlertController.alertMessage(title: "Error", message: message, vc: self)
    }
}

extension HomeViewController: LoadingShowable {}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel?.loadMoreGames()
        }
    }
}
