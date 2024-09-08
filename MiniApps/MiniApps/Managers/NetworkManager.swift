//
//  NetworkManager.swift
//  MiniApps
//
//  Created by Evelina on 04.09.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest(with query: String) async throws -> Data
}

final class NetworkManager: NSObject, NetworkManagerProtocol {
    
    // MARK: - Implement NetworkManagerProtocol
    func makeRequest(with query: String) async throws -> Data {
        guard let url = URL(string: query) else { throw URLError(.badURL) }
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse)}
        return data
    }
}
