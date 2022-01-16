//
//  APIRouterProtocol.swift
//  APIKit
//
//  Created by Subhra Roy on 15/01/22.
//

import Foundation

public enum ServiceError:Error{
    case invalid
    case nodata
    case parseError
}

public protocol APIRouterProtocol{
    func fetch<T: Decodable>(completion: @escaping (Swift.Result<T, ServiceError>) -> ())
}
