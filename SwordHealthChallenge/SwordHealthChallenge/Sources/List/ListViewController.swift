
import Foundation
import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func listViewControllerDidTappedItem(controller: ListViewController, item: DogBreed)
}

class ListViewController: UIViewController {
    var delegate: ListViewControllerDelegate?
    
    enum Section {
        case main
    }
    enum LayoutType {
        case grid
        case list
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, DogBreed>! = nil
    var collectionView: UICollectionView!
    
    var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .black
        return loadingView
    }()
    
    lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Data not loaded"
        errorLabel.textColor = .red
        return errorLabel
    }()
    var layoutType: LayoutType = .list
    
    private var viewModel: ListViewModelProtocol
    private var dogBreedData: [DogBreed]?
    
    init(viewModel: ListViewModelProtocol = ListViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.title = "List"
        setupListeners()
        setupLoading()
        configureHierarchy()
        configureDataSource()
        viewModel.loadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Style", style: .plain, target: self, action: #selector(changeStyle))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Order", style: .plain, target: self, action: #selector(orderList))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupListeners() {
        viewModel.outputEvents.didLoadData = { [weak self] data in
            self?.dogBreedData = data
            self?.reloadItem(with: data)
            
        }
        viewModel.outputEvents.displayLoading = { [weak self] isLoading in
            self?.displayLoading(isLoading: isLoading)
        }
        viewModel.outputEvents.loadDataError = {  [weak self]  in
            self?.showError()
        }
    }
    
    @objc
    func changeStyle(){
        switch layoutType {
        case .grid:
            collectionView.collectionViewLayout = setupListLayout()
        case .list:
            collectionView.collectionViewLayout = setupGridLayout()
            
        }
    }
    
    @objc
    func orderList(){
        viewModel.sortData()
    }
    
}

extension ListViewController {
    private func setupLoading() {
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 30),
            loadingView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func displayLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading{
                self.loadingView.startAnimating()
            } else {
                self.loadingView.stopAnimating()
            }
            self.loadingView.isHidden = !isLoading
            
            self.collectionView.isHidden = isLoading
        }
    }
    private func showError(){
        DispatchQueue.main.async {
            self.view.addSubview(self.errorLabel)
            NSLayoutConstraint.activate([
                self.errorLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        }
        
        
    }
}

extension ListViewController {
    
    private func setupListLayout() -> UICollectionViewLayout {
        self.layoutType = .list
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupGridLayout() -> UICollectionViewLayout {
        self.layoutType = .grid
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: nil,
                                                         trailing: .flexible(16), bottom: nil)
        let itemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                               heightDimension: .fractionalHeight(1))
        let item2 = NSCollectionLayoutItem(layoutSize: itemSize2)
        item2.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil,
                                                          trailing: .flexible(0), bottom: nil)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item, item2])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupListLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DogBreed>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: DogBreed) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ListCollectionViewCell else { fatalError("Cannot create new cell") }
            
            cell.configureCell(imageURL: identifier.image?.url, name: identifier.name )
            
            return cell
        }
        
    }
    
    func reloadItem(with data: [DogBreed]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DogBreed>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dogBreedData = self.dogBreedData else { return }
        delegate?.listViewControllerDidTappedItem(controller: self, item: dogBreedData[indexPath.row])
    }
    
    
}
