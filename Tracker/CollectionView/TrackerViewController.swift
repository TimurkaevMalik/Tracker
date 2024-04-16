//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 04.04.2024.
//

import UIKit


final class TrackerViewController: UIViewController {
    
    private lazy var plusButton = UIButton()
    private lazy var datePicker = UIDatePicker()
    private lazy var titleLabel = UILabel()
    private lazy var centralPlugLabel = UILabel()
    private lazy var centralPlugImage = UIImageView()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var tracker: [Tracker] = []
    
    private let ShowCreatingTrackerViewSegueIdentifier = "ShowCreatingTrackerView"
    private let cellIdentifier = "collectionCell"
    
    private let params = GeomitricParams(cellCount: 2, leftInset: 18, rightInset: 18, cellSpacing: 7)
    
    
    private func configureTrackerButtonsViews() {
        
        plusButton = UIButton.systemButton(with: UIImage(named: "PlusImage") ?? UIImage(), target: self, action: #selector(didTapPlusButton))
        plusButton.tintColor = UIColor(named: "YPBlack")
        
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.backgroundColor = UIColor(named: "YPLightGray")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func configureTrackerLabelsViews(){
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        
        centralPlugLabel.text = "Что будем отслеживать?"
        centralPlugLabel.font = UIFont.systemFont(ofSize: 12)
        centralPlugLabel.textAlignment = .center
        
        centralPlugLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([titleLabel, centralPlugLabel])
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            centralPlugLabel.widthAnchor.constraint(equalToConstant: 150),
            centralPlugLabel.heightAnchor.constraint(equalToConstant: 18),
            centralPlugLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 403),
            centralPlugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureCentralPlug(){
        centralPlugImage.image = UIImage(named: "TrackerPlug")
        
        centralPlugImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centralPlugImage)
        
        NSLayoutConstraint.activate([
            centralPlugImage.widthAnchor.constraint(equalToConstant: 80),
            centralPlugImage.heightAnchor.constraint(equalToConstant: 80),
            centralPlugImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centralPlugImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 315)
        ])
    }
    
    private func configureSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.layer.cornerRadius = 8
        searchController.searchBar.layer.masksToBounds = true
        
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.backgroundImage = UIImage()
        
        
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchController.searchBar)
        
        
        NSLayoutConstraint.activate([
            searchController.searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchController.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 49),
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 11),
            searchController.searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11)
        ])
    }
    
    private func configureCollectionView(){
        
        registerCollectionViewsSubviews()
        
        collectionView.backgroundColor = .ypWhite
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    private func registerCollectionViewsSubviews(){
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func configureTrackerViews(){
        view.backgroundColor = UIColor(named: "YPWhite")
        
        configureCentralPlug()
        configureTrackerLabelsViews()
        configureSearchController()
        configureCollectionView()
        configureTrackerButtonsViews()
    }
    
    private func presentCreatingTrackerView(){
        
        let viewController = TrackerTypeController()
        viewController.delegate = self
        
        present(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTrackerViews()
    }
    
    
    @objc func didTapPlusButton(){
        
        print("PLUS BUTTON")
        
        completedTrackers.append(TrackerRecord(id: UUID(), date: Date()))
        
        print(completedTrackers.count)
        print(completedTrackers)
        
        presentCreatingTrackerView()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        print("DATE BUTTON")
        
        let selctedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formatedDate = dateFormatter.string(from: selctedDate)
        
        print(formatedDate)
    }
}


extension TrackerViewController: HabbitTrackerControllerProtocol {
    
    func addNewTracker(trackerCategory: TrackerCategory) {
        print("add new tracker tapped")
        
        
        self.dismiss(animated: true)
        
        tracker.removeAll()
        
        var oldCount: Int
        var newCount: Int
        var newCategorie: TrackerCategory
        
        print(tracker)
        
        if !categories.isEmpty {
            
            oldCount = categories[0].habbitsArray.count
            
            for index in 0..<categories[0].habbitsArray.count {
                tracker.append(categories[0].habbitsArray[index])
            }
            tracker.append(trackerCategory.habbitsArray[0])

            newCategorie = TrackerCategory(titleOfCategory: trackerCategory.titleOfCategory, habbitsArray: tracker)
            
            categories[0] = newCategorie
            
            newCount = categories[0].habbitsArray.count
        } else {
            oldCount = 0
            
            tracker.append(trackerCategory.habbitsArray[0])
            
            newCategorie = TrackerCategory(titleOfCategory: trackerCategory.titleOfCategory, habbitsArray: tracker)
            categories.append(newCategorie)
            
            newCount = categories[0].habbitsArray.count
        }
        
        
        print(oldCount)
        print(newCount)
        
        if oldCount != newCount {
            collectionView.performBatchUpdates {
                
                var indexPaths: [IndexPath] = []
                
                for count in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: count, section: 0))
                }
                collectionView.insertItems(at: indexPaths)
            }
        }
        
    }
    
    func dismisTrackerTypeController() {
        self.dismiss(animated: true)
    }
}


extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if categories.count == 0 {
            collectionView.backgroundColor? = .white.withAlphaComponent(0)
        } else {
            collectionView.backgroundColor = .ypWhite
        }
        
        return categories.isEmpty ? 0 :
        categories[section].habbitsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.emoji.text = categories[indexPath.section].habbitsArray[indexPath.row].emoji
        cell.nameLable.text = categories[indexPath.section].habbitsArray[indexPath.row].name
        cell.view.backgroundColor = categories[indexPath.section].habbitsArray[indexPath.row].color
        cell.doneButton.backgroundColor = categories[indexPath.section].habbitsArray[indexPath.row].color
        
        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availibleSpacing = collectionView.frame.width - params.paddingWidth
        let cellWidth = availibleSpacing / params.cellCount
        
        return CGSize(width: cellWidth, height: cellWidth - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

extension TrackerViewController: UICollectionViewDelegate {
    
}


extension TrackerViewController: UISearchBarDelegate {
    
}


extension TrackerViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController){}
}
