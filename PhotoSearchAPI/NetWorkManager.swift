//
//  NetWorkManager.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/20/25.
//

import Alamofire
import Foundation

enum UnplashRequest{
    case searchPhotos(query: String, page: Int, sort: SortState)
    case topicPhotos(topicId: String)
    case photoStatistics(id: String)
    
    var baseURL: String{
        return "https://api.unsplash.com/"
    }
    
    var endpoint: URL {
        switch self {
        case .searchPhotos(let query, let page, let sort):
            return URL(string: baseURL + "search/photos?query=\(query)&page=\(page)&order_by=\(sort.rawValue)")!
        case .topicPhotos(let topicId):
            return URL(string: baseURL + "topics/\(topicId)/photos")!
        case .photoStatistics(let id):
            return URL(string: baseURL + "photos/\(id)/statistics")!
        }
    }
    
    var method: HTTPMethod{
        return .get
    }
    
    var parameter: Parameters{
        switch self{
        case .searchPhotos(_, let page,_):
            return[
                "per_page": "20",
                "page": page,
                "client_id": ApiKey.client_ID
            ]
        case .topicPhotos:
            return ["client_id": ApiKey.client_ID]
        case .photoStatistics:
            return ["client_id": ApiKey.client_ID]
        }
    }
}

class NetworkManager{
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequest<T: Decodable>(api: UnplashRequest, succesHandler: @escaping (T) -> Void, failHandler: @escaping (Error) -> Void){
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameter)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self){ response in
                switch response.result{
                case .success(let value):
                    succesHandler(value)
                case .failure(let error):
                    failHandler(error)
                }
                
            }
    }
}

