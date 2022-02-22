import Foundation
protocol DetailViewModelProtocol {
    var outputEvents: DetailViewModel.OutputEvents { get set }
    func loadImageIfNeeded()
    var dogBreed: DogBreed { get }
}

public class DetailViewModel: DetailViewModelProtocol {
    
    var dogBreed: DogBreed
    let getImageUseCase: GetImageUseCase
    var dogBreedList: [DogBreed] = []
    var outputEvents: OutputEvents = .init()
    
    struct OutputEvents {
        var didLoadImage: ((DogBreedImage?) -> Void)?
    }
    
    init(dogBreed: DogBreed,
         getImageUseCase: GetImageUseCase = GetImageUseCaseImpl() ) {
        
        self.getImageUseCase = getImageUseCase
        self.dogBreed = dogBreed
    }
    
    func loadImageIfNeeded() {
     
        if let _ = dogBreed.image { return }
        
        getImageUseCase.execute(dogBreed.reference_image_id) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self.outputEvents.didLoadImage?(data)
            case .failure:
               return
            }
        }
    }
    
    
    
    
}
