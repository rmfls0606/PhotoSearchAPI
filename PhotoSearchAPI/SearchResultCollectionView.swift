//
//  SearchResultCollectionView.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/19/25.
//

import Foundation

import UIKit
import SnapKit
import Kingfisher


final class SearchResultCollectionView: BaseCollectionViewCell{
    
    static let identifier = "SearchResultCollectionView"
    
    private lazy var itemImageView = UIImageView()
    private lazy var starImage = UIImageView()
    private lazy var starText = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [starImage, starText])
    
    
    override func configureHierarchy() {
        self.contentView.addSubview(itemImageView)
        self.contentView.addSubview(stackView)
    }
    
    override func configureLayout() {
        self.itemImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.contentView)
            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(self.contentView.snp.width)
        }
        
        starImage.snp.makeConstraints { make in
//            make.leading.equalTo(stackView.snp.leading).offset(5)
            make.centerY.equalTo(stackView)
        }
        
        starText.snp.makeConstraints { make in
//            make.trailing.equalTo(stackView.snp.trailing).offset(-5)
            make.centerY.equalTo(stackView)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
//            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        
        self.contentView.backgroundColor = .black
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.cornerRadius = 10
        itemImageView.layer.masksToBounds = true
        
        starImage.image = UIImage(systemName: "star.fill")
        starImage.tintColor = .yellow
        
        starText.text = "fdafdsfdsa"
        
        stackView.spacing = 6
        stackView.axis = .horizontal
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
    }
    
//    func configureData(data: Item){
//        self.itemImageView.kf.setImage(with: URL(string: data.image))
//        self.itemTitle.text = data.mallName
//        self.itemSubTitle.text = data.title.htmlEscaped
//        let result = Int(data.lprice)?.formatted(.number)
//        self.itemPrice.text = result
//        
//    }
}

////정규식으로 html태그 제거
//extension String {
//    var htmlEscaped: String {
//        do {
//            let regex = try NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
//            let range = NSRange(location: 0, length: self.utf16.count)
//            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
//        } catch {
//            print("Regex error: \(error)")
//            return self
//        }
//    }
//}
