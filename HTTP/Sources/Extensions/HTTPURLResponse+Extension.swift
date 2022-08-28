import Foundation

extension HTTPURLResponse {
    public var isSuccess: Bool { 200...299 ~= self.statusCode }
}
