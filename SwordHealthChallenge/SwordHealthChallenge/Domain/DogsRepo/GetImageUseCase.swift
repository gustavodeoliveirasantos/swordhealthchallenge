import Foundation

public protocol GetImageUseCase {
    func execute(_ filter: String?, callback: @escaping (Result<DogBreedImage?, Error >) -> Void)
}

final class GetImageUseCaseImpl: UseCase, GetImageUseCase {
    private let repository: DogBreedRepository
    
    init (repository: DogBreedRepository =  DogBreedRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(_ filter: String?, callback: @escaping (Result<DogBreedImage?, Error>) -> Void) {
        repository.getImage(imageId: filter, completion: callback)
    }
}
