
import Foundation
import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SearchCollectionViewCell"
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let originLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayout () {
        
        contentView.backgroundColor = .blue.withAlphaComponent(0.2)
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(originLabel)
        stack.addArrangedSubview(groupLabel)
        
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        ])
    }
    
    public func configureCell( name: String?, group: String?, origin: String?) {
        nameLabel.text = "Name: \(name ?? "not found")"
        groupLabel.text = "Group: \(group ?? "not found")"
        originLabel.text = "Origin: \(origin ?? "not found")"
    
    }
}
