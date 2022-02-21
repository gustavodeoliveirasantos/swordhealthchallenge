
import Foundation
import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func listViewControllerDidTappedItem(controller: ListViewController, item: Any)
}

class ListViewController: UIViewController {
    weak var delegate: ListViewControllerDelegate?
    private var viewModel: ListViewModelProtocol
    
    
    init(viewModel: ListViewModelProtocol = ListViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        viewModel.loadData()
    }
}
