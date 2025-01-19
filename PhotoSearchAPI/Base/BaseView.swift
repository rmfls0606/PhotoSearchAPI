//
//  BaseView.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/19/25.
//

import UIKit

class BaseView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy(){ }
    
    func configureLayout(){ }
    
    func configureView(){ }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

