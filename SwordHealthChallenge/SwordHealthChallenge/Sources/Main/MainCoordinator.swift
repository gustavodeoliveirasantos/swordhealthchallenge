import Foundation
import UIKit

protocol Coordinator {
    func start()
}

public class MainCoordinator: Coordinator {
    private let window: UIWindow?
    let tabBarController: MainViewController = MainViewController()
    
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }

        let listNagivationController = setupListViewControler()
        let searchNavigationController = setUpSearchViewController()
        
        let viewControllers = [listNagivationController,
                               searchNavigationController]
        
        let tabBarController = MainViewController()
        tabBarController.viewControllers = viewControllers
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func setupListViewControler() -> UINavigationController {
        let listViewController =  ListViewController()
        listViewController.delegate = self
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [listViewController]
        
        let icon = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        navigationController.tabBarItem = icon
    
     
        return navigationController
    }

    private func setUpSearchViewController()  -> UINavigationController  {
        let searchViewController = SearchViewController()
        searchViewController.delegate = self
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [searchViewController]
        
        let icon = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        navigationController.tabBarItem = icon
        return navigationController
    }
    
    private func goToDetailPage(controller: UIViewController, item: DogBreed) {
        let detailViewController = DetailViewController(with: item)
        controller.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}

//DELEGATES
extension MainCoordinator: ListViewControllerDelegate, SearchViewControllerDelegate {
    func listViewControllerDidTappedItem(controller: ListViewController, item: DogBreed) {
        goToDetailPage(controller: controller, item: item)
    }
    

    func searchViewControllerDidTappedItem(controller: SearchViewController, item: DogBreed)
    {   goToDetailPage(controller: controller, item: item)
    }
    
    
}
