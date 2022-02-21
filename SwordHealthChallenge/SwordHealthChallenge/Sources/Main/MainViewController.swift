import Foundation
import UIKit


class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  UITabBar.appearance().barTintColor = UIColor.white
        
        self.tabBar.barTintColor = UIColor.white
    }
}
