//
//  APIRouter.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/25.
//

import Foundation
import WebKit

enum APIRouter {
    
    // MARK: Base URL
    static let baseURL = "https://api.unsplash.com"
    
    // MARK: Cases
    // GET
    case getRandomPhoto(clientId: String)
    case getPhotos(clientId: String, page: Int)
    case searchPhotos(clientId: String, page: Int, query: String)
    
    // MARK: HTTPMethod
    private var method: String {
        switch self {
        case .getRandomPhoto, .getPhotos, .searchPhotos:
            return "GET"
        }
    }
    
    // MARK: Path
    private var path: String {
        switch self {
        case .getRandomPhoto:
            return "/photos/random"
        case .getPhotos:
            return "/photos"
        case .searchPhotos:
            return "/search/photos"
        }
    }
    
    // MARK: Parameters
    private var parameters: [String: Any]? {
        switch self {
        case .getRandomPhoto, .getPhotos, .searchPhotos:
            return nil
        }
    }
    
    // MARK: QueryStrings
    private var queryItems: [URLQueryItem]? {
        var queryItems = [URLQueryItem]()
        switch self {
        case .getRandomPhoto(let clientId):
            queryItems.append(URLQueryItem(name: "client_id", value: clientId))
            return queryItems
        case .getPhotos(let clientId, let page):
            queryItems.append(URLQueryItem(name: "client_id", value: clientId))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            return queryItems
        case .searchPhotos(let clientId, let page, let query):
            queryItems.append(URLQueryItem(name: "client_id", value: clientId))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            queryItems.append(URLQueryItem(name: "query", value: "\(query)"))
            return queryItems
        }
    }
    
    // MARK: HTTPHeader
    private func getAdditionalHttpHeaders() -> [(String, String)] {
        var headers = [(String, String)]()
        switch self {
        case .getRandomPhoto, .getPhotos, .searchPhotos:
            headers = [(String, String)]()
            return headers
        }
    }
    
    func asURLRequest() -> URLRequest {
        // Base URL
        let url: URL = URL(string: APIRouter.baseURL)!
        
        // Path
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        
        // QueryStrings
        if let queryItems = queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        // URLRequest
        var urlRequest = URLRequest(url: urlComponents!.url!)
        
        // HTTP Method
        urlRequest.httpMethod = method
        
        // Common Headers
        urlRequest.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptEncoding.rawValue)
        
        // Additional Headers
        let headers = getAdditionalHttpHeaders()
        headers.forEach { (header) in
            urlRequest.addValue(header.1, forHTTPHeaderField: header.0)
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        return urlRequest
    }
}
