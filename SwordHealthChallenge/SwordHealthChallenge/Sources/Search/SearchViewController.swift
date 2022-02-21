
import Foundation
import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewControllerDidTappedItem(controller: SearchViewController, item: Any)
}

class SearchViewController: UIViewController {
    weak var delegate: SearchViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}

