//
//  EmojiCollectionPresenter.swift
//  Tracker
//
//  Created by Malik Timurkaev on 29.04.2024.
//

import UIKit

class EmojiCollectionPresenter: UIViewController {
    
    private lazy var emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let params = GeomitricParams(cellCount: 6, leftInset: 18, rightInset: 18, cellSpacing: 5)
    private let reuseCellIdentifier = "emojiCollectioCell"
    private let reuseHeaderIdentifier = "emojiColectionHeader"
    private let emojis: [String] = ["🙂", "🐶", "🌺", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    func configureCollectionUnder(tableView: UITableView, of viewController: UIViewController){
        
        emojiCollection.delegate = self
        emojiCollection.dataSource = self
        emojiCollection.backgroundColor = .ypBlue
        emojiCollection.allowsMultipleSelection = false
        emojiCollection.isScrollEnabled = false
        
        emojiCollection.contentInset = UIEdgeInsets(top: 24, left: params.leftInset, bottom: -24, right: params.rightInset)
        
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(emojiCollection)
        
        NSLayoutConstraint.activate([
            emojiCollection.heightAnchor.constraint(equalToConstant: 204),
            emojiCollection.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            emojiCollection.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            emojiCollection.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor)
        ])
        
        registerCollectionViewsSubviews()
        
//        callCellMethods()
        
    }
    
    private func registerCollectionViewsSubviews(){
        emojiCollection.register(EmojiCollectionCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        
        emojiCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
    }
    
    private func callCellMethods(){
        
        emojiCollection.performBatchUpdates {
            var indexPaths = [IndexPath]()
            
            for index in 0...16 {
                
                indexPaths.append(IndexPath(row: index, section: 0))
            }
            
            emojiCollection.insertItems(at: indexPaths)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


extension EmojiCollectionPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as? EmojiCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.emoji = emojis[indexPath.row]
        cell.backgroundColor = .ypLightGray
        return cell
    }
}

extension EmojiCollectionPresenter: UICollectionViewDelegate {
    
}
