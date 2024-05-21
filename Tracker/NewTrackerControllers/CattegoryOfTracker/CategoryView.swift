//
//  CattegoryOfTracker.swift
//  Tracker
//
//  Created by Malik Timurkaev on 19.04.2024.
//

import UIKit


final class CategoryView: UIViewController {
    
    private let viewModel: CategoryViewModel
    private weak var delegate: CategoryOfTrackerDelegate?
    
    private let doneButton = UIButton()
    private let buttonContainer = UIView()
    private let titleLabel = UILabel()
    private let tableView = UITableView()

    private var chosenCategory: String?
    
    init?(delegate: CategoryOfTrackerDelegate, wasChosenCategory category: String?){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let categoryStore = TrackerCategoryStore(appDelegate: appDelegate)
        
        chosenCategory = category
        self.delegate = delegate
        self.viewModel = CategoryViewModel(categoryStore: categoryStore)
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
        tableView.showsVerticalScrollIndicator = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([tableView])
        view.insertSubview(tableView, belowSubview: buttonContainer)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor/*, constant: CGFloat(Float(bottomConstant))*/),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDoneButton(){
        buttonContainer.backgroundColor = .ypWhite
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        doneButton.backgroundColor = .ypBlack
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews([buttonContainer, doneButton])
        
        NSLayoutConstraint.activate([
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            buttonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonContainer.topAnchor.constraint(equalTo: doneButton.topAnchor, constant: -3),
            buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func shouldSetCheckmarkForCell(_ indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        
        if let chosenCategory {
            if chosenCategory == viewModel.categories[indexPath.row] {
                return .checkmark
            }
        }
        
        return .none
    }
    
    private func updateTableViewCells(categories: [String]) {
        
        let newCount = categories.count
        
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
        
        if chosenCategory == nil {
            doneButton.setTitle("Создать категорию", for: .normal)
        } else {
            doneButton.setTitle("Добавить категорию", for: .normal)
        }
        
        view.backgroundColor = .ypWhite
        
        configureTitleLabelView()
        configureDoneButton()
        configureTableView()
        
        viewModel.categoriesBinding = { [weak self] categories in
            guard let self = self else { return }
            
            self.updateTableViewCells(categories: categories)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.didDismissScreenWithChangesIn(chosenCategory)
    }
    
    
    @objc func doneButtonTapped(){
        
        if  let chosenCategory {
            delegate?.didChooseCategory(chosenCategory)
            dismiss(animated: true)
        } else {
            let viewController = MakeNewCategory(viewModel: viewModel)
            present(viewController, animated: true)
        }
    }
}


extension CategoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if viewModel.categories.count < 8 {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? CategoryCellView else {
            return UITableViewCell()
        }
        
        cell.accessoryType = shouldSetCheckmarkForCell(indexPath)
        cell.layer.masksToBounds = true
        cell.setCornerRadiusForCell(at: indexPath, of: tableView)
        
        cell.backgroundColor = .ypLightGray
        cell.separatorInset = UIEdgeInsets(top: 0.3, left: 16, bottom: 0.3, right: 16)
    
        if !viewModel.categories.isEmpty {
            cell.nameOfCategory = viewModel.categories[indexPath.row]
        }
        cell.awakeFromNib()
        
        return cell
    }
}


extension CategoryView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            
            chosenCategory = nil
            doneButton.setTitle("Создать категорию", for: .normal)
        } else {
            
            for cells in tableView.visibleCells {
                cells.accessoryType = .none
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
            chosenCategory = viewModel.categories[indexPath.row]
            doneButton.setTitle("Добавить категорию", for: .normal)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
