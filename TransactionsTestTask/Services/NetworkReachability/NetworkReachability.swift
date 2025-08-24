import Foundation
import Network
import Combine

protocol NetworkReachability: AnyObject {
    var isConnected: Bool { get }

    var connectionStatusPublisher: AnyPublisher<Bool, Never> { get }
}

final class NetworkReachabilityImpl: NetworkReachability {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "network.reachability", qos: .utility)
    private let subject = CurrentValueSubject<Bool, Never>(false)
    private var last: Bool?

    var isConnected: Bool {
        last ?? false
    }

    var connectionStatusPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let now = (path.status == .satisfied)
            if self.last != now {
                self.last = now
                self.subject.send(now)
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
