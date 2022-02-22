
import Foundation

public struct DogBreed: Decodable, Hashable {
    let id: Int
    let name: String
    let origin: String?
    let breed_group: String? //Used instead "category"
    let temperament: String?
    let image: DogBreedImage?
    let reference_image_id: String?
}

public struct DogBreedImage: Decodable, Hashable {
    let url: String?
}
