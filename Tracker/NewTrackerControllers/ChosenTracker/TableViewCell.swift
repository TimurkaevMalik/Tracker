//
//  TableViewCell.swift
//  Tracker
//
//  Created by Malik Timurkaev on 01.05.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let cellText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell(){
        
        NSLayoutConstraint.activate([
            cellText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            cellText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            cellText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func updateTextOfCellWith(name: String, text: String){
        
        if !text.isEmpty {
            self.cellText.text = "\(name)\n\(text)"
        }
    }
}
