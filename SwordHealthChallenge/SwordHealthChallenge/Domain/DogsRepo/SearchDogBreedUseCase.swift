import Foundation

public protocol SearchDogBreedUseCase {
    func execute(_ filter: String?, callback: @escaping (Result<[DogBreed]?, Error >) -> Void)
}

final class SearchDogBreedUseCaseImpl: UseCase, SearchDogBreedUseCase {
    private let repository: DogBreedRepository
    
    init (repository: DogBreedRepository =  DogBreedRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(_ filter: String?, callback: @escaping (Result<[DogBreed]?, Error>) -> Void) {
        repository.searchData(filter: filter, completion: callback)
    }
}
