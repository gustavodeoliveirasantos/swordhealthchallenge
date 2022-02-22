
import Foundation
import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewControllerDidTappedItem(controller: SearchViewController, item: DogBreed)
}

class SearchViewController: UIViewController {
    var delegate: SearchViewControllerDelegate?
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, DogBreed>! = nil
    var collectionView: UICollectionView!
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .black
        return loadingView
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "Search for results :)"
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .red
        return messageLabel
    }()
    
    private var viewModel: SearchViewModelProtocol
    private var dogBreedData: [DogBreed]?
    
    init(viewModel: SearchViewModelProtocol = SearchViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.title = "Search"
        setupListeners()
        setupLoading()
        setupMessageLabel()
        setupSearchBar()
        configureHierarchy()
        configureDataSource()
        
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
        viewModel.outputEvents.showMessage = {  [weak self] message  in
            
            self?.showMessage(message: message)
        }
    }
    
}

extension SearchViewController {
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
            self.messageLabel.isHidden = isLoading
            self.collectionView.isHidden = isLoading
        }
    }
    private func showMessage(message: String) {
        DispatchQueue.main.async {
            self.messageLabel.isHidden = false
            self.messageLabel.text = message
            self.collectionView.isHidden = true
        }
    }
}

extension SearchViewController {
    
    private func setupListLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    private func setupSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupListLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
    }
    
    
    private func setupMessageLabel() {
        view.addSubview(messageLabel)
            NSLayoutConstraint.activate([
                self.messageLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.messageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DogBreed>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: DogBreed) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier,
                for: indexPath) as? SearchCollectionViewCell else { fatalError("Cannot create new cell") }
            
            cell.configureCell(name: identifier.name, group: identifier.breed_group, origin: identifier.origin)
            
            return cell
        }
        
    }
    
    func reloadItem(with data: [DogBreed]) {
        collectionView.isHidden = false
        messageLabel.isHidden = true
        var snapshot = NSDiffableDataSourceSnapshot<Section, DogBreed>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterData(by: searchText)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dogBreedData = self.dogBreedData else { return }
        delegate?.searchViewControllerDidTappedItem(controller: self, item: dogBreedData[indexPath.row])
    }
    
    
}
