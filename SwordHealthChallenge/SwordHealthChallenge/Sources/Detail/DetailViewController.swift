//
//  DetailViewController.swift
//  YellowIpeChallenge
//
//  Created by Gustavo de Oliveira Santos on 14/02/2022.
//

import Foundation
import UIKit
public class DetailViewController: UIViewController {
    private var viewModel: DetailViewModelProtocol
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder_image")
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
    private var categoryLabel: UILabel = {
        let groupLabel = UILabel()
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        groupLabel.textColor = .black
        groupLabel.textAlignment = .center
        return groupLabel
    }()
    
    private var temperamentLabel: UILabel = {
        let originLabel = UILabel()
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        originLabel.textColor = .black
        originLabel.numberOfLines = 3
        originLabel.textAlignment = .center
        return originLabel
    }()
    
    init(viewModel: DetailViewModelProtocol) {
 
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupListeners()
        setupLayout()
        viewModel.loadImageIfNeeded()
     
    }
    
    
    private func setupListeners() {
        viewModel.outputEvents.didLoadImage = { [weak self] data in
            self?.imageView.loadImage(from: data?.url)
        }
    }
    
    
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        imageView.loadImage(from: viewModel.dogBreed.image?.url)
        
        nameLabel.text = viewModel.dogBreed.name
        categoryLabel.text = "Group: \(viewModel.dogBreed.breed_group ?? "unknown")"
        temperamentLabel.text = "Temperament: \(viewModel.dogBreed.temperament ?? "unknown")"
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(categoryLabel)
        view.addSubview(temperamentLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            
            nameLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            categoryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            categoryLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            temperamentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            temperamentLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            temperamentLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
          
        ])
    
    }
    
}
