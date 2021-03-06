import Foundation

public protocol GetDogBreedUseCase {
    func execute(_ filter: String?, callback: @escaping (Result<[DogBreed]?, Error >) -> Void)
}

final class GetDogBreedUseCaseImpl: UseCase, GetDogBreedUseCase {
    private let repository: DogBreedRepository
    
    init (repository: DogBreedRepository =  DogBreedRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(_ filter: String?, callback: @escaping (Result<[DogBreed]?, Error>) -> Void) {
        repository.getDogBreedData(completion: callback)
    }
}
