//
//  APIBucket.swift
//  APIKit
//
//  Created by Subhra Roy on 15/01/22.
//

import Foundation

public struct APIBucket: APIRouterProtocol{
    
    private let apiUrl: String
    
    public init(url: String) {
        self.apiUrl = url
    }
    
    public func fetch<T: Decodable>(completion: @escaping (Swift.Result<T, ServiceError>) -> ()) {
        
        guard let url: URL = URL(string: self.apiUrl) else {
            completion(.failure(.invalid))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.nodata))
                return
            }
            
            do{
                if let result: T = try self.parse(data: data){
                    completion(.success(result))
                }
            }catch{
                completion(.failure(.nodata))
            }
            
        }.resume()
    }
    
    private func parse<T>(data: Data) throws -> T where T: Decodable{
        
        do{
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .useDefaultKeys
            let response = try jsonDecoder.decode(T.self, from: data)
            return response
        }catch {
            throw ServiceError.parseError
        }
    }
}
