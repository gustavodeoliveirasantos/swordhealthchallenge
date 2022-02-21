import Foundation
protocol ListViewModelProtocol {
    var outputEvents: ListViewModel.OutputEvents { get set }
    func loadData()
    func sortData()
}


public class ListViewModel: ListViewModelProtocol {
    
    let getDogBreedUseCase: GetDogBreedUseCase
    var dogBreedList: [DogBreed] = []
    var isOrdered: Bool = true
    
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
                 self.dogBreedList = data
                 self.outputEvents.didLoadData?(data)
                 self.outputEvents.displayLoading?(false)
             case .failure(let error):
                 print(error.localizedDescription)
                 self.outputEvents.loadDataError?()
             }
         }
    }
    
    func sortData() {
        var dogBreedListSorted: [DogBreed]
        if isOrdered {
            dogBreedListSorted = dogBreedList.sorted { $0.name > $1.name }
        } else {
            dogBreedListSorted = dogBreedList.sorted { $0.name < $1.name }
        }
        isOrdered.toggle()
       
        self.outputEvents.didLoadData?(dogBreedListSorted)
    }
   
}
