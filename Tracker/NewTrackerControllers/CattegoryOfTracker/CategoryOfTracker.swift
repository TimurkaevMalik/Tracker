//
//  CattegoryOfTracker.swift
//  Tracker
//
//  Created by Malik Timurkaev on 19.04.2024.
//

import UIKit


final class CategoryOfTracker: UIViewController {
    
    private var viewModel: CategoryViewModel
    private weak var delegate: CategoryOfTrackerDelegate?
    
    private let doneButton = UIButton()
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    
//    private var categories: [String] = ["Важное"]
    private var categoryWasChosenBefore: String?
    private var chosenCategory: String?
    
    init(delegate: CategoryOfTrackerDelegate){
        self.delegate = delegate
        self.viewModel = CategoryViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureTitleLabelView(){
        titleLabel.text = "Категория"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([titleLabel])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureTableView(){
        
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
        
//        let bottomConstant = viewModel.categories.count * 75 > 599 ? 599 : viewModel.categories.count * 75 - 1
//        
//        if viewModel.categories.count * 75 <= 599 {
//            tableView.isScrollEnabled = false
//        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor/*, constant: CGFloat(Float(bottomConstant))*/),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDoneButton(){
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.setTitle("Добавить категорию", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        doneButton.backgroundColor = .ypBlack
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews([doneButton])
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func highLightButton(){
        
        UIView.animate(withDuration: 0.3) {
            
            self.doneButton.backgroundColor = .ypRed
            
        } completion: { isCompleted in
            if isCompleted {
                resetButtonColor()
            }
        }
        
        func resetButtonColor(){
            UIView.animate(withDuration: 0.3) {
                self.doneButton.backgroundColor = .ypBlack
            }
        }
    }
    
    private func shouldSetCheckmarkForCell(_ indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        
        if let categoryWasChosenBefore {
            if categoryWasChosenBefore == viewModel.categories[indexPath.row] {
                return .checkmark
            }
        }
        
        return .none
    }
    
    func ifWasCategoryChosenBefore(category: String?){
        
        if let category {
            categoryWasChosenBefore = category
            self.chosenCategory = category
        }
    }
    
    private func updateTableViewCells(categories: [String]) {
        
        let newCount = categories.count
        print(categories)
        
        tableView.performBatchUpdates {
            
            let lastIndex = IndexPath(row: newCount - 1, section: 0)
            tableView.insertRows(at: [lastIndex], with: .top)
            
            if newCount > 1 {
                let secondLastIndex = IndexPath(row: newCount - 2, section: 0)
                tableView.reloadRows(at: [secondLastIndex], with: .fade)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureTitleLabelView()
        configureTableView()
        configureDoneButton()
        
        viewModel.categoriesBinding = {  categories in
//            guard let self = self else { return }
//            self.tableView.reloadData()
//            if self.tableView.visibleCells.count == 0 {
//                self.tableView.reloadData()
//            } else {
                self.updateTableViewCells(categories: categories)
//            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.didDismissScreenWithChangesIn(chosenCategory)
    }
    
    
    @objc func doneButtonTapped(){
        
        viewModel.storeNewCategory(TrackerCategory(titleOfCategory: "New" + "\(viewModel.categories.count)", trackersArray: []))
        
//        guard let chosenCategory else {
//            
//            highLightButton()
//            return
//        }
//        
//        delegate?.didChooseCategory(chosenCategory)
//        
//        dismiss(animated: true)
    }
}


extension CategoryOfTracker: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = viewModel.categories.count
        print(count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? CategoryCellView else {
            return UITableViewCell()
        }
        print(indexPath)
        cell.accessoryType = shouldSetCheckmarkForCell(indexPath)
        cell.layer.masksToBounds = true
        cell.setCornerRadiusForCell(at: indexPath, of: tableView)
        
        cell.backgroundColor = .ypLightGray
        cell.separatorInset = UIEdgeInsets(top: 0.3, left: 16, bottom: 0.3, right: 16)
//        cell.viewModel = viewModel.categories[indexPath.row]
        if !viewModel.categories.isEmpty {
            cell.nameOfCategory = viewModel.categories[indexPath.row]
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
            
            chosenCategory = viewModel.categories[indexPath.row]
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
