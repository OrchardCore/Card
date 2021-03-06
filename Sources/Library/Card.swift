import Foundation
import UIKit

public typealias Card = UIView & Cardable

public protocol Cardable: class {
    
    associatedtype Model: Resource
    
    var model: Model? { get set }
    
    static func create () -> Self
    static func defaultSize () -> CGSize
}

extension Cardable {
    
    public static func loadedFromNib<T: AnyObject>() -> T {
        let bundle = Bundle.init(for: T.self)
        let view = bundle.loadNibNamed(String(describing: T.self), owner: self, options: nil)![0]
        guard let castView = view as? T else {
            fatalError("Nib exists by the correct name but first view was not a \(String(describing: T.self))")
        }
        return castView
    }
}

extension Cardable where Self: UIView {
    
    public func createImageSnapshot(size: CGSize = Self.defaultSize()) -> UIImage? {
        
        let rect: CGRect = .init(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal) else {
            return nil
        }
        
        return newImage
    }
}
