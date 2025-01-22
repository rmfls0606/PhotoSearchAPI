//
//  HorizontalScrollView.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/22/25.
//

import UIKit
import SnapKit
import Kingfisher

class HorizontalScrollView: UIView{
    
    private lazy var topicTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.addSubview(stackView)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()
    
    init(title: String, images: [String]){
        super.init(frame: .zero)
        setUp()
        topicTitle.text = title
        addImages(images)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        addSubview(topicTitle)
        addSubview(scrollView)
        
        topicTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(24)
//            make.leading.equalToSuperview().offset(12)
//            make.trailing.equalToSuperview().offset(-12)
//            make.height.equalTo(200)
            make.top.equalTo(topicTitle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func addImages(_ images: [String]) {
          for imageName in images {
              let imageView = createImageView(imageName: imageName)
              stackView.addArrangedSubview(imageView)
              
              let width = (UIScreen.main.bounds.width - 24 - 10) / 2
              imageView.snp.makeConstraints { make in
                  make.width.equalTo(width)
                  make.height.equalTo(250)
              }
          }
      }
      
      private func createImageView(imageName: String) -> UIImageView {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.clipsToBounds = true
          imageView.layer.cornerRadius = 8
          imageView.kf.setImage(with: URL(string: imageName))
          return imageView
      }
}
