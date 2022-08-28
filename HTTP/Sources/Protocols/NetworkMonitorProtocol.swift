import Foundation

public protocol NetworkMonitorProtocol {
    typealias OnChange = (_ isConnected: Bool) -> Void
    
    /// The delegate of the network monitor.
    var onChange: OnChange? { get set }
    
    /// Indicates whether there is network connectivity or not.
    var isConnected: Bool { get }
}
