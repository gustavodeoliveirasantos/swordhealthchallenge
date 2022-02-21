//
//  GoggleRepoStore.swift
//  YellowIpeChallenge
//
//  Created by Gustavo de Oliveira Santos on 13/02/2022.
//

import Foundation

//STORE
public protocol Store {
}

public protocol DogBreedStore {
    func load() -> [DogBreed]?
    func save(items: [DogBreed])
}

final class DogBreedStoreImpl: DogBreedStore {
    private var items: [DogBreed]?
    
    static let shared = DogBreedStoreImpl()
   
    func load() -> [DogBreed]? {
        return items
    }
    func save(items: [DogBreed]) {
        self.items = items
    }
}

