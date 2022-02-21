
import Foundation

//WEBAPI DATASOURCE
public protocol DogBreedService {
    func getData(completion: @escaping (Result<[DogBreed]?, DogBreedServiceError>) -> Void)
}


public enum DogBreedServiceError: Swift.Error {
    case failedToGetDataFromAPI
}


final class DogBreedServiceImpl: DogBreedService {
    private struct Constants {
         static let apiKey = "c9381192-3eab-47fa-b8e0-eb68c8811eb9"
         static let serviceUrl = "https://api.thedogapi.com/v1/breeds"
    }
   
    
    func getData(completion: @escaping (Result<[DogBreed]?, DogBreedServiceError>) -> Void) {
        guard let url = URL(string: Constants.serviceUrl) else {
            completion(.failure(.failedToGetDataFromAPI))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("x-api-key'", forHTTPHeaderField: Constants.apiKey)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedToGetDataFromAPI))
                return
            }
            
            let decodedData = try? JSONDecoder().decode([DogBreed].self, from: data)
            completion(.success(decodedData))
            
        }
        task.resume()
    }
    
    
}


