//
//  NetworkMonitor.swift
//  NetworkConnectivityCheck
//
//  Created by Alphonsa Varghese on 16/05/23.
//

import Foundation
import Hyperconnectivity
import Combine

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private var cancellable: AnyCancellable?
    public private(set) var isConnected: Bool = false
    var count = 0
    func startConnectivityChecks(_ completion: @escaping(_ count: Int) -> ()) {
       
        cancellable = Hyperconnectivity.Publisher()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] _ in
                self?.stopConnectivityChecks()
                }, receiveValue: { [weak self] connectivityResult in
                    self?.updateConnectionStatus(connectivityResult, completion: { count in
                        completion(count)
                    })
                    
            })
        
       
    }
    
    func stopConnectivityChecks() {
        cancellable?.cancel()
    }
    
    func updateConnectionStatus(_ result: ConnectivityResult, completion: @escaping(_ count: Int) -> ()) {
        print("status = ",result.isConnected)
        print("network state = ",result.state.description)
        isConnected = result.isConnected
       
        print("count = ", count)
        if isConnected {
            count = count+1
            completion(count)
        } else {
            UserDefaults.standard.set(false, forKey: "isFirst")
            count = 0
            completion(count)
        }
    }
}
