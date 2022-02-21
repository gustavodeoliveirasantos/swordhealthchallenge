
import Foundation

public struct DogBreed: Decodable, Hashable {
    let id: Int
    let name: String?
    let origin: String?
    let breed_group: String?
    let image: DogBreedImage?
 //   let referenceImageId: Int?
}

public struct DogBreedImage: Decodable, Hashable {
    let url: String?
}
