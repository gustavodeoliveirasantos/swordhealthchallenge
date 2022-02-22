import Foundation
protocol SearchViewModelProtocol {
    var outputEvents: SearchViewModel.OutputEvents { get set }
    func filterData(by name: String)
}

public class SearchViewModel: SearchViewModelProtocol {
 
    let searchDogBreeUseCase: SearchDogBreedUseCase
    var dogBreedList: [DogBreed] = []
    var outputEvents: OutputEvents = .init()
    
    struct OutputEvents {
        var didLoadData: (([DogBreed]) -> Void)?
        var displayLoading: ((Bool) -> Void)?
        var showMessage: ((String) -> Void)?
    }
    
    init(searchDogBreeUseCase: SearchDogBreedUseCase = SearchDogBreedUseCaseImpl() ) {
        self.searchDogBreeUseCase = searchDogBreeUseCase
    }
    
    private func loadData(filter: String?) {
        outputEvents.displayLoading?(true)
        searchDogBreeUseCase.execute (filter) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                print(data.count)
                self.dogBreedList = data
                self.outputEvents.didLoadData?(data)
                self.outputEvents.displayLoading?(false)
            case .failure(let error):
                print(error.localizedDescription)
                self.outputEvents.showMessage?( error.localizedDescription)
            }
        }
    }
    
    func filterData(by name: String) {
        if name.isEmpty {
            self.outputEvents.showMessage?("Search for results :)")
        } else {
            loadData(filter: name)
        }
    }
    
    
    
}
