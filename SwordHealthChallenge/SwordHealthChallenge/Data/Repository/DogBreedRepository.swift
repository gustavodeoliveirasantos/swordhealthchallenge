import Foundation

//REPOSITORY -> ONDE VAI BUSCAR OS DADOS E RETORNAR
public protocol DogBreedRepository {
    func getDogBreedData(completion: @escaping (Result<[DogBreed]?, Error>) -> Void)
    func searchData(filter: String?, completion: @escaping (Result<[DogBreed]?, Error>) -> Void)
    func getImage(imageId: String?, completion: @escaping (Result<DogBreedImage?, Error>) -> Void)
}

class DogBreedRepositoryImpl: DogBreedRepository {
   
    
    private let store: DogBreedStore
    private let service: DogBreedService
    init(service: DogBreedService = DogBreedServiceImpl(),
         store: DogBreedStore = DogBreedStoreImpl.shared) {
        
        self.service = service
        self.store = store
    }
    
    func getDogBreedData( completion: @escaping (Result<[DogBreed]?, Error>) -> Void) {
        
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
    
    func searchData(filter: String?, completion: @escaping (Result<[DogBreed]?, Error>) -> Void) {
        service.searchData(filter: filter) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(DogBreedServiceError.failedToSearch))
                    return
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getImage(imageId: String?, completion: @escaping (Result<DogBreedImage?, Error>) -> Void) {
        service.getImage(imageId: imageId) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(DogBreedServiceError.failedToGetImage))
                    return
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}










