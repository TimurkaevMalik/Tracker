//
//  EmojiCollectionPresenter.swift
//  Tracker
//
//  Created by Malik Timurkaev on 29.04.2024.
//

import UIKit

class EmojiCollectionPresenter: UIViewController {
    
    private lazy var emojiCollection = UICollectionView()
    
    private let params = GeomitricParams(cellCount: 6, leftInset: 18, rightInset: 18, cellSpacing: 5)
    private let reuseCellIdentifier = "emojiCollectioCell"
    private let reuseHeaderIdentifier = "emojiColectionHeader"
    private let emojis: [String] = ["🙂", "🐶", "🌺", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    func configureCollectionUnder(tableView: UITableView, of viewController: UIViewController){
        
        emojiCollection.delegate = self
        emojiCollection.dataSource = self
        emojiCollection.backgroundColor = .ypWhite
        emojiCollection.allowsMultipleSelection = false
        emojiCollection.isScrollEnabled = false
        
        emojiCollection.contentInset = UIEdgeInsets(top: 24, left: params.leftInset, bottom: -24, right: params.rightInset)
        
        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            emojiCollection.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            emojiCollection.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor)
        ])
    }
    
    private func registerCollectionViewsSubviews(){
        emojiCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        
        emojiCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
    }
}


extension EmojiCollectionPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath)
        
        
        return UICollectionViewCell()
    }
}

extension EmojiCollectionPresenter: UICollectionViewDelegate {
    
}
