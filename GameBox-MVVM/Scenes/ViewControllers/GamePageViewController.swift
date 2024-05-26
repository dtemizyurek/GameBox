//
//  GamePageViewController.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 24.05.2024.
//

// GamePageViewController.swift
import UIKit

final class GamePageViewController: UIPageViewController {
    fileprivate var items: [UIViewController] = []
    private var gameSource: [GamesUIModel]?
    private var currentIndex: Int?
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        decoratePageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    fileprivate func decoratePageControl() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [GamePageViewController.self])
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.pageIndicatorTintColor = .gray
    }
    
    @objc func changeImage() {
        goToNextPage()
    }
    
    func goToNextPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    func populateItems(gameSource: [GamesUIModel]) {
        self.gameSource = gameSource
        self.items.removeAll()
        
        let limitedGameSource = Array(gameSource.prefix(3)) // İlk üç oyunu almak için
        
        for game in limitedGameSource {
            let vc = UIViewController()
            let gameView = GamePageView(frame: view.frame)
            vc.view.addSubview(gameView)
            gameView.setImage(from: game.backgroundImage)
            items.append(vc)
        }
        
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }
}


extension GamePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return items.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }
    
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return items.last
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < items.count else {
            return items.first
        }
        
        return items[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = items.firstIndex(of: currentViewController) {
                currentIndex = index
            }
        }
    }
}
