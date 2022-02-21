
import Foundation
import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func listViewControllerDidTappedItem(controller: ListViewController, item: Any)
}

class ListViewController: UIViewController {
    
    weak var delegate: ListViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}
