//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Malik Timurkaev on 14.04.2024.
//

import Foundation
import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    let nameLable = UILabel()
    let emoji = UILabel()
    let daysCount = UILabel()
    let doneButton = UIButton()
    private var count = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        configureLabels()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabels(){
        
        nameLable.textAlignment = .left
        nameLable.numberOfLines = 2
        nameLable.font = UIFont.systemFont(ofSize: 12)
        nameLable.textColor = UIColor(named: "YPWhite")
        daysCount.font = UIFont.systemFont(ofSize: 12)
        daysCount.textColor = UIColor(named: "YPBlack")
        daysCount.text = "\(count) день"
        
        emoji.backgroundColor = UIColor(named: "YPWhite")?.withAlphaComponent(0.3)
        
        
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        daysCount.translatesAutoresizingMaskIntoConstraints = false
        emoji.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews([nameLable, emoji, daysCount])
        
        NSLayoutConstraint.activate([
            nameLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 12),
            nameLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44),
            
            emoji.widthAnchor.constraint(equalToConstant: 24),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            emoji.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emoji.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            daysCount.widthAnchor.constraint(equalToConstant: 101),
            daysCount.heightAnchor.constraint(equalToConstant: 18),
            daysCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCount.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16)
        ])
    }
    
    func configureButton(){
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.layer.cornerRadius = 65
        doneButton.layer.masksToBounds = true
        doneButton.imageView?.image = UIImage(named: "PlusImage")
        doneButton.backgroundColor = contentView.backgroundColor
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 12)
        ])
    }
    
    @objc func didTapDoneButton(){
        
        if doneButton.imageView?.image?.pngData() == UIImage(named: "PlusImage")?.pngData() {
            
            doneButton.setImage(UIImage(named: "CheckMark"), for: .normal)
            count += 1
            daysCount.text = "\(count) день"
        } else {
            
            doneButton.setImage(UIImage(named: "PlusImage"), for: .normal)
            count -= 1
            daysCount.text = "\(count) день"
        }
    }
}
