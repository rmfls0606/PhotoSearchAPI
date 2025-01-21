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
    let total_pages: Int
    let results: [SearchResult]
}

struct SearchResult: Decodable{
    let id: String
    let urls: SearchURLS
    let likes: Int
}

struct SearchURLS: Decodable{
    let thumb: String
}

enum SortState: String{
    case sortByRelevance = "relevant"
    case sortByLatest = "latest"
    
    mutating func toggle(){
        switch self{
        case .sortByRelevance:
            self = .sortByLatest
        case .sortByLatest:
            self = .sortByRelevance
        }
    }
}

class SearchPhotoViewController: UIViewController{

    private var SearchData = [SearchResult]()
    private var query = ""
    private var sortState: SortState = SortState.sortByRelevance
    private var page = 1
    private var isEnd = false
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "키워드 검색"
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder!, attributes: [.foregroundColor: UIColor.lightGray])
        searchBar.searchTextField.textColor = .lightGray
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton(configuration: .filled())
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        config.background.strokeColor = .gray
        config.background.strokeWidth = 1.0
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        var title = AttributedString("관련순")
        title.font = UIFont.systemFont(ofSize: 16)
        config.attributedTitle = title
        
        button.configuration = config
        
        button.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var searchResult = SearchResultView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp(){
        self.navigationItem.title = "SEARCH PHOTO"
        self.view.backgroundColor = .white
        
        self.view.addSubview(searchBar)
        self.view.addSubview(searchResult)
        self.view.addSubview(toggleButton)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        searchResult.snp.makeConstraints { make in
            make.top.equalTo(toggleButton.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        searchResult.configureDelegate(delegate: self, dataSource: self, prefetchDataSource: self)
    }
    
    private func callRequest(query: String, page: Int){
        let url = "https://api.unsplash.com/search/photos?"
        let parameters: [String: Any] = [
            "query": query,
            "per_page": "20",
            "page": page,
            "order_by": self.sortState.rawValue,
            "client_id": ApiKey.client_ID
        ]
        
        NetworkManager.shared.loadData(url: url,
                                       method: .get,
                                       parameters: parameters) { (result: Result<SearchResponse, Error>) in
            switch result{
            case .success(let data):
                if self.page == 1{
                    self.SearchData = data.results
                }else{
                    self.SearchData.append(contentsOf: data.results)
                }
                self.isEnd = page >= data.total_pages
                
                self.searchResult.reloadData()
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
        
    }
    
    @objc
    private func toggleButtonTapped(){
        self.sortState.toggle()
        self.page = 1
        self.toggleButton.setTitle(self.sortState.rawValue, for: .normal)
        self.toggleButton.setTitle(self.sortState.rawValue, for: .highlighted)
        callRequest(query: query, page: 1)
    }
}

extension SearchPhotoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        guard let query = searchBar.text else{
            print("검색 에러")
            return
        }
        self.query = query
        self.page = 1
        callRequest(query: query, page: 1)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
}

extension SearchPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SearchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionView", for: indexPath) as? SearchResultCollectionView else{
            return UICollectionViewCell()
        }
        let data = SearchData[indexPath.item]
        cell.configureData(data: data)
        
        return cell
    }
}

extension SearchPhotoViewController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard !isEnd else { return }
        
        for item in indexPaths{
            if SearchData.count - 5 <= item.item{
                self.page += 1
                callRequest(query: query, page: self.page)
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
    
    
}
