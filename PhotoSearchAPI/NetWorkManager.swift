//
//  NetWorkManager.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/20/25.
//

import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    
    private init() {}
    
    func loadData<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ){
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   headers: headers).responseDecodable(of: T.self) { response in
            switch response.result{
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

