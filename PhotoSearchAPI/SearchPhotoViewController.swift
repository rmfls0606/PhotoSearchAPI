//
//  SearchPhotoViewController.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/19/25.
//

import UIKit
import SnapKit
import Alamofire

struct SearchResponse: Decodable{
    let results: [SearchResult]
}

struct SearchResult: Decodable{
    let id: String
    let width: Int
    let height: Int
    let urls: SearchURLS
    let likes: Int
}

struct SearchURLS: Decodable{
    let thumb: String
}

class SearchPhotoViewController: UIViewController{

    private var SearchData = [SearchResult]()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder!, attributes: [.foregroundColor: UIColor.lightGray])
        searchBar.searchTextField.textColor = .lightGray
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var searchResult = SearchResultView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        callRequest(query: "음식")
    }
    
    private func setUp(){
        self.navigationItem.title = "SEARCH PHOTO"
        self.view.backgroundColor = .white
        
        self.view.addSubview(searchBar)
        self.view.addSubview(searchResult)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        searchResult.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        searchResult.configureDelegate(delegate: self, dataSource: self, prefetchDataSource: self)
    }
    
    private func callRequest(query: String){
        let url = "https://api.unsplash.com/search/photos?"
        let parameters: [String: Any] = [
            "query": query,
            "per_page": "20",
            "client_id": ApiKey.client_ID
        ]
        
        NetworkManager.shared.loadData(url: url,
                                       method: .get,
                                       parameters: parameters) { (result: Result<SearchResponse, Error>) in
            switch result{
            case .success(let data):
                self.SearchData = data.results
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
        
    }
}

extension SearchPhotoViewController: UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionView", for: indexPath) as? SearchResultCollectionView else{
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}

extension SearchPhotoViewController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    
}
