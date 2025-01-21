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
    private lazy var starButton = UIButton(configuration: .filled())
    
    override func configureHierarchy() {
        self.contentView.addSubview(itemImageView)
        self.contentView.addSubview(starButton)
    }
    
    override func configureLayout() {
        self.itemImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.contentView)
        }
        
        starButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    override func configureView() {
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        
        starButton.setTitle("", for: .normal)
        starButton.setTitle("", for: .highlighted)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .darkGray
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        config.imagePadding = 5
        
        let smallImage = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular, scale: .small)
        let image = UIImage(systemName: "star.fill", withConfiguration: smallImage)?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        starButton.setImage(image, for: .normal)
        starButton.setImage(image, for: .highlighted)
        
        var title = AttributedString("")
        title.font = UIFont.systemFont(ofSize: 14)
        config.attributedTitle = title
        
        starButton.configuration = config
    }
    
    func configureData(data: SearchResult){
        let liksetText = data.likes.formatted(.number)
        self.itemImageView.kf.setImage(with: URL(string: data.urls.small))
        self.starButton.setTitle(liksetText, for: .normal)
        self.starButton.setTitle(liksetText, for: .highlighted)
    }
}
