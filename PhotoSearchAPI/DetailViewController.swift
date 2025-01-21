//
//  DetailViewController.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/22/25.
//

import UIKit
import Kingfisher

struct StatisticsResponse: Decodable{
    let downloads: StatisticsDownload
    let views: StatisticsView
}

struct StatisticsDownload: Decodable{
    let total: Int
}

struct StatisticsView: Decodable{
    let total: Int
}

class DetailViewController: UIViewController {

    var item: SearchResult?
    private var statisticsData: StatisticsResponse? = nil
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        callRequest(id: item!.id)
    }
    
    private func setUp(){
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        
        imageView.kf.setImage(with: URL(string: item!.urls.small))
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
    
    private func callRequest(id: String){
        let url = "https://api.unsplash.com/photos/\(id)/statistics?"
        
        let parametr: [String: Any] = [
            "client_id": ApiKey.client_ID
        ]
        
        NetworkManager.shared.loadData(url: url,
                                       method: .get,
                                       parameters: parametr,
                                       completion: {(result: Result<StatisticsResponse, Error>) in
            switch result {
            case .success(let success):
                self.statisticsData = success
                print(success)
            case .failure(let failure):
                fatalError(failure.localizedDescription)
            }
        })
    }
}
