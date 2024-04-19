//
//  CattegoryOfTracker.swift
//  Tracker
//
//  Created by Malik Timurkaev on 19.04.2024.
//

import UIKit


class CategoryOfTracker: UIViewController {
    
    var delegate: CategoryOfTrackerDelegate?
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()

    private var categories: [String] = ["Важное", "Очень важное", "Не важное"]
    private var chosenCategory: String?
    
    func configureTitleLabelView(){
        titleLabel.text = "Категория"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([titleLabel])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureTableView(){
        
        tableView.backgroundColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CategoryCellView.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.allowsMultipleSelection = false

        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([tableView])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 525),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureTitleLabelView()
        configureTableView()
    }
}


extension CategoryOfTracker: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return !categories.isEmpty ? categories.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? CategoryCellView else {
            return UITableViewCell()
        }
        
        
//        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.setCornerRadiusForCell(at: indexPath, of: tableView)
        
        cell.backgroundColor = .ypLightGray
        cell.separatorInset = UIEdgeInsets(top: 0.3, left: 16, bottom: 0.3, right: 16)
        
        if !categories.isEmpty {
            cell.nameOfCategory = categories[indexPath.row]
        }
        cell.awakeFromNib()
        
        return cell
    }
}


extension CategoryOfTracker: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            
            chosenCategory = nil

        } else {
            
            for cells in tableView.visibleCells {
                cells.accessoryType = .none
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
            chosenCategory = categories[indexPath.row]
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
