//
//  DetailViewController.swift
//  YellowIpeChallenge
//
//  Created by Gustavo de Oliveira Santos on 14/02/2022.
//

import Foundation
import UIKit
public class DetailViewController: UIViewController {
    
    private let dogBreed: DogBreed
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .blue
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        return nameLabel
    }()
    private var groupLabel: UILabel = {
        let groupLabel = UILabel()
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        groupLabel.textColor = .black
        groupLabel.textAlignment = .center
        return groupLabel
    }()
    
    private var originLabel: UILabel = {
        let originLabel = UILabel()
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        originLabel.textColor = .black
        originLabel.numberOfLines = 3
        originLabel.textAlignment = .center
        return originLabel
    }()
    
    init(with dogBreed: DogBreed) {
        self.dogBreed = dogBreed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
     
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        imageView.loadImage(from: dogBreed.image?.url)
        
        nameLabel.text = dogBreed.name
        groupLabel.text = "Group: \(dogBreed.breed_group ?? "unknown")"
        originLabel.text = "Origin: \(dogBreed.origin ?? "unknown")"
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(groupLabel)
        view.addSubview(originLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            
            nameLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            groupLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            groupLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            groupLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            originLabel.topAnchor.constraint(equalTo: groupLabel.bottomAnchor, constant: 10),
            originLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            originLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
          
        ])
    
    }
    
}
