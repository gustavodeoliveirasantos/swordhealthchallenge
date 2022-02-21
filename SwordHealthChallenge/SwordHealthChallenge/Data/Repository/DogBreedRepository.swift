import Foundation

//REPOSITORY -> ONDE VAI BUSCAR OS DADOS E RETORNAR
public protocol DogBreedRepository {
    func getDogBreedData(completion: @escaping (Result<[DogBreed]?, Error>) -> Void)
}

class DogBreedRepositoryImpl: DogBreedRepository {
    
    private let store: DogBreedStore
    private let service: DogBreedService
    init(service: DogBreedService = DogBreedServiceImpl(),
         store: DogBreedStore = DogBreedStoreImpl()) {
  
        self.service = service
        self.store = store
        print("Hello teste")
    }
    
    func getDogBreedData(completion: @escaping (Result<[DogBreed]?, Error>) -> Void) {
        service.getData { result in
            switch result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
                //GET DATA from storage
                
                
            }
        }
    }
    
    
    
}










