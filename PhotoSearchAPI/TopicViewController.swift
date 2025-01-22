//
//  TopicViewController.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/22/25.
//

import UIKit
import SnapKit

struct TopicResponse: Decodable{
    let likes: Int
    let urls: TopicURLs
}

struct TopicURLs: Decodable{
    let small: String
}


class TopicViewController: UIViewController {
    
    private var data = [TopicResponse]()
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OUR TOPIC"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 50
        view.alignment = .fill
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        callRequest(topicId: "golden-hour")
        callRequest(topicId: "business-work")
        callRequest(topicId: "architecture-interior")
    }
    
    private func setUp(){
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(12)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
    private func addHorizontalScrollView(title: String){
        
        let horizontalScrollView = HorizontalScrollView(title: title, images: data.map{$0.urls.small})
        stackView.addArrangedSubview(horizontalScrollView)
        
        horizontalScrollView.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
        
    }
    
    private func callRequest( topicId: String){
        NetworkManager.shared.callRequest(api: .topicPhotos(topicId: topicId)) { (response: [TopicResponse]) in
            self.data = response
            if topicId == "golden-hour"{
                self.addHorizontalScrollView(title: "골든 아워")
            }else if topicId == "business-work"{
                self.addHorizontalScrollView(title: "비즈니스 및 업무")
            }else{
                self.addHorizontalScrollView(title: "건축 및 인테리어")
            }
            
        } failHandler: { error in
            print(error.localizedDescription)
        }
        
    }
}
