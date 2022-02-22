
import Foundation

//WEBAPI DATASOURCE
public protocol DogBreedService {
    func getData(completion: @escaping (Result<[DogBreed]?, DogBreedServiceError>) -> Void)
    func searchData(filter: String?, completion: @escaping (Result<[DogBreed]?, DogBreedServiceError>) -> Void)
    func getImage(imageId: String?, completion: @escaping (Result<DogBreedImage?, DogBreedServiceError>) -> Void)
}



public enum DogBreedServiceError: Swift.Error {
    case failedToGetDataFromAPI
    case failedToSearch
    case failedToGetImage
}


final class DogBreedServiceImpl: DogBreedService {
    
    private struct Constants {
        static let apiKey = "c9381192-3eab-47fa-b8e0-eb68c8811eb9"
        static let baseUrl = "https://api.thedogapi.com/v1/"
        static let loadUrl =  baseUrl + "breeds"
        static let searchUrl = baseUrl + "breeds/search?q="
        static let imageUrl = baseUrl + "images/"
        
    }
    
    func getImage(imageId: String?, completion: @escaping (Result<DogBreedImage?, DogBreedServiceError>) -> Void) {
        let finalUrl = "\(Constants.imageUrl)\(imageId ?? "")"
        guard let url = URL(string: finalUrl) else {
            completion(.failure(.failedToGetImage))
            return
        }
        
        self.requestData(url: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedToGetImage))
                return
            }
            
            let decodedData = try? JSONDecoder().decode(DogBreedImage.self, from: data)
            completion(.success(decodedData))
        }
        
        
    }
    
    func searchData(filter: String?, completion: @escaping (Result<[DogBreed]?, DogBreedServiceError>) -> Void) {
        let finalUrl = "\(Constants.searchUrl)\(filter ?? "")"
        guard let url = URL(string: finalUrl) else {
            completion(.failure(.failedToSearch))
            return
        }
        
        self.requestData(url: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedToSearch))
                return
            }
            
            let decodedData = try? JSONDecoder().decode([DogBreed].self, from: data)
            completion(.success(decodedData))
        }
        
        
    }
    
    func getData(completion: @escaping (Result<[DogBreed]?, DogBreedServiceError>) -> Void) {
        
        guard let url = URL(string: Constants.loadUrl) else {
            completion(.failure(.failedToGetDataFromAPI))
            return
        }
        
        self.requestData(url: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedToGetDataFromAPI))
                return
            }
            
            let decodedData = try? JSONDecoder().decode([DogBreed].self, from: data)
            completion(.success(decodedData))
        }
        
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("x-api-key'", forHTTPHeaderField: Constants.apiKey)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
        }
        task.resume()
    }
    
    private func requestData(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("x-api-key'", forHTTPHeaderField: Constants.apiKey)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
}


