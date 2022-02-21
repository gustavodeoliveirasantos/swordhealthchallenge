
import Foundation

public protocol UseCase {
    associatedtype Input
    associatedtype Output
    associatedtype Error: Swift.Error
    
    func execute(_ input: Input?, callback: @escaping (Result<Output, Error>) -> Void)
}
