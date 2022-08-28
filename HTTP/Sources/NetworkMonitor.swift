import Foundation
import Network

/// Monitors network connectivity.
public final class NetworkMonitor: NetworkMonitorProtocol {
    public var onChange: OnChange?

    /// Indicates whether there is network connectivity or not.
    public var isConnected: Bool {
        self.monitor.currentPath.status == .satisfied
    }

    // Private
    private let queue = DispatchQueue(label: UUID().uuidString)
    private let monitor = NWPathMonitor()

    // MARK: Initialization

    /// Initializes a new `NetworkMonitor` instance.
    /// - Parameter onChange: A closure that is called when
    /// connection status changes.
    public init(_ onChange: OnChange? = nil) {
        self.onChange = onChange
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            let isConnected = path.status == .satisfied
            self.onChange?(isConnected)
        }

        self.monitor.start(queue: queue)
    }

    deinit {
        self.monitor.cancel()
    }
}
