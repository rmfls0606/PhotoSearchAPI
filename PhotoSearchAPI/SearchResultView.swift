//
//  SearchResultView.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/19/25.
//

import UIKit
import SnapKit

class SearchResultView: BaseView{
    private(set) lazy var collectionView = createCollectionView()
    
    func createCollectionView() -> UICollectionView{
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(SearchResultCollectionView.self, forCellWithReuseIdentifier: SearchResultCollectionView.identifier)
        collectionView.collectionViewLayout = createCollectionViewLayout()
        return collectionView
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout{
        let padding = 12.0
        let spacing = 12.0
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = spacing
        let width = (UIScreen.main.bounds.width - (padding * 2) - (spacing)) / 2
        layout.itemSize = CGSize(width: width, height: 260)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
    }
    
    override func configureView() {
        
    }
    
    func configureDelegate(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, prefetchDataSource: UICollectionViewDataSourcePrefetching){
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = dataSource
        self.collectionView.prefetchDataSource = prefetchDataSource
    }
    
    func reloadData(){
        self.collectionView.reloadData()
    }
}
