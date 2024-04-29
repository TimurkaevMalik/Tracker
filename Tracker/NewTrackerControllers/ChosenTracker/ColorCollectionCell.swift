//
//  CollorCollectionCell.swift
//  Tracker
//
//  Created by Malik Timurkaev on 29.04.2024.
//

import UIKit

class CollorCollectionCell: UICollectionViewCell {
    
    let colorCell = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureColorCell(){
        colorCell.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorCell)
        
        NSLayoutConstraint.activate([
            colorCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
