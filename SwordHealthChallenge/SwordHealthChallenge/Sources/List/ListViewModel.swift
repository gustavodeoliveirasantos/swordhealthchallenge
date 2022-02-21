import Foundation
protocol ListViewModelProtocol {
    var outputEvents: ListViewModel.OutputEvents { get set }
    func loadData()
}


public class ListViewModel: ListViewModelProtocol {
    
    let getDogBreedUseCase: GetDogBreedUseCase
    var repoInfo: [DogBreed] = []
    
    struct OutputEvents {
        var didLoadData: (([DogBreed]) -> Void)?
        var displayLoading: ((Bool) -> Void)?
        var loadDataError: (() -> Void)?
    }
    var outputEvents: OutputEvents = .init()
    
   
    init(getDogBreedUseCase: GetDogBreedUseCase = GetDogBreedUseCaseImpl() ) {
        self.getDogBreedUseCase = getDogBreedUseCase
    }
    
    
     func loadData() {
         outputEvents.displayLoading?(true)
         getDogBreedUseCase.execute ("") { result in
             switch result {
             case .success(let data):
                 guard let data = data else { return }
                 self.outputEvents.didLoadData?(data)
                 self.outputEvents.displayLoading?(false)
             case .failure(let error):
                 print(error.localizedDescription)
                 self.outputEvents.loadDataError?()
             }
         }
    }
   
}
