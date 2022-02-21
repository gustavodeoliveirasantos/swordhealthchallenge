
import Foundation
import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewControllerDidTappedItem(controller: SearchViewController, item: DogBreed)
}

class SearchViewController: UIViewController {
    weak var delegate: SearchViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}

