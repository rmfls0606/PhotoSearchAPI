//
//  DetailViewController.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/22/25.
//

import UIKit
import Kingfisher
import SnapKit

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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정보"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var sizeLabel = createLabel(text: "크기")
    private lazy var viewsLabel = createLabel(text: "조회수")
    private lazy var downloadsLabel = createLabel(text: "다운로드")
    
    private lazy var sizeValueLabel = createLabel(text: "\(item!.width) x \(item!.height)")
    private lazy var viewsValueLabel = createLabel(text: "")
    private lazy var downloadsValueLabel = createLabel(text: "")
    
    private lazy var keyStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sizeLabel, viewsLabel, downloadsLabel])
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    private lazy var valueStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sizeValueLabel, viewsValueLabel, downloadsValueLabel])
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .trailing
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [keyStackView, valueStackView])
        view.axis = .horizontal
        view.spacing = 16
        return view
    }()
    
    private lazy var boxView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, mainStackView])
        view.spacing = 30
        view.axis = .horizontal
        return view
    }()
    
//    private lazy var scrollView: UIScrollView = {
//        let view = UIScrollView(frame: .zero)
//        view.addSubview(imageView)
//        view.addSubview(titleLabel)
//        view.addSubview(mainStackView)
//        return view
//    }()
    
//    private lazy var outerview: UIStackView = {
//        let view = UIStackView(arrangedSubviews: [imageView, titleLabel,])
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        callRequest(id: item!.id)
    }
    
    private func setUp(){
        self.view.backgroundColor = .white
        self.view.addSubview(boxView)
//        self.view.addSubview(scrollView)
        self.view.addSubview(imageView)
//        self.view.addSubview(titleLabel)
//        view.addSubview(mainStackView)
        self.sizeLabel.font = .boldSystemFont(ofSize: 14)
        self.viewsLabel.font = .boldSystemFont(ofSize: 14)
        self.downloadsLabel.font = .boldSystemFont(ofSize: 14)
        
        boxView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(12)
        }
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide)
//            make.leading.bottom.trailing.equalToSuperview()
//        }
        
        imageView.kf.setImage(with: URL(string: item!.urls.small))
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
//            make.height.equalTo(1000)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(boxView)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(boxView)
            make.leading.equalTo(titleLabel.snp.trailing).offset(30)
            make.trailing.equalTo(boxView)
            
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
                self.viewsValueLabel.text = success.views.total.formatted(.number)
                self.downloadsValueLabel.text = success.downloads.total.formatted(.number)
            case .failure(let failure):
                fatalError(failure.localizedDescription)
            }
        })
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }
}
