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
    
    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: GamesCollectionViewCell.self)
        print(viewModel.numberOfItems)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }
    
}

extension HomeViewController : ConfigureCollectionView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(cellType: GamesCollectionViewCell.self, indexPath: indexPath)
        let games = viewModel.game(index: indexPath)
        cell.configure(games: games)
        
        return cell
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
}

extension HomeViewController: LoadingShowable {}
