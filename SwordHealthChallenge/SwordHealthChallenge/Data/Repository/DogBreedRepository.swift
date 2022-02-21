import Foundation

//REPOSITORY -> ONDE VAI BUSCAR OS DADOS E RETORNAR
public protocol DogBreedRepository {
    func getDogBreedData(completion: @escaping (Result<[DogBreed]?, Error>) -> Void)
}

class DogBreedRepositoryImpl: DogBreedRepository {
    
    private let store: DogBreedStore
    private let service: DogBreedService
    init(service: DogBreedService = DogBreedServiceImpl(),
         store: DogBreedStore = DogBreedStoreImpl.shared) {
        
        self.service = service
        self.store = store
        print("Hello teste")
    }
    
    func getDogBreedData(completion: @escaping (Result<[DogBreed]?, Error>) -> Void) {
        if let dogBreedData = store.load() {
            completion(.success(dogBreedData))
        } else {
            service.getData { result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        completion(.failure(DogBreedServiceError.failedToGetDataFromAPI))
                        return
                    }
                    completion(.success(data))
                    self.store.save(items: data)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
    }
    
}










