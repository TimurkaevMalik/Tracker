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
    private var visibleTrackers: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var trackers: [Tracker] = []
    
    private let cellIdentifier = "collectionCell"
    private let headerIdentifier = "footerIdentifier"
    
    private let params = GeomitricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 7)
    
    private func configureTrackerButtonsViews() {
        
        plusButton = UIButton.systemButton(with: UIImage(named: "PlusImage") ?? UIImage(), target: self, action: #selector(didTapPlusButton))
        plusButton.tintColor = UIColor(named: "YPBlack")
        
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.backgroundColor = UIColor(named: "YPLightGray")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        datePicker.timeZone = TimeZone.current
        
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
        
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
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
    
    private func showVisibleTrackers(dateDescription: String){
        
        var selectedDate: String = ""
        
        visibleTrackers.removeAll()
        print(visibleTrackers.isEmpty)
        
        for char in dateDescription {
            if char != "," {
                selectedDate.append(char)
            } else {
                break
            }
        }
        
        print("🔰\(selectedDate)")
        
        for category in categories {
            
            trackers.removeAll()
            
            for tracker in category.trackersArray {
                
                if !tracker.schedule.isEmpty {
                    for date in tracker.schedule {
                        if date == selectedDate {
                            
                            trackers.append(tracker)
                        }
                    }
                } else  {
                    trackers.append(tracker)
                }
            }
            
            visibleTrackers.append(TrackerCategory(titleOfCategory: category.titleOfCategory, trackersArray: trackers))
        }
        
        collectionView.reloadData()
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
        
        print(sender.date)
        showVisibleTrackers(dateDescription: sender.date.description(with: .current))
    }
}


extension TrackerViewController: HabbitTrackerControllerDelegate {
    
    func addNewTracker(trackerCategory: TrackerCategory) {
        print("add new tracker tapped")
        
        
        self.dismiss(animated: true)
        
        trackers.removeAll()
        
        var oldCount: Int
        var newCount: Int
        var newCategorie: TrackerCategory
        
        print("🔰\(trackers)")
        
        if !categories.isEmpty {
            
            oldCount = categories[0].trackersArray.count
            
            for index in 0..<categories[0].trackersArray.count {
                trackers.append(categories[0].trackersArray[index])
            }
            trackers.append(trackerCategory.trackersArray[0])

            newCategorie = TrackerCategory(titleOfCategory: trackerCategory.titleOfCategory, trackersArray: trackers)
            
            categories[0] = newCategorie
            
            newCount = categories[0].trackersArray.count
        } else {
            oldCount = 0
            
            trackers.append(trackerCategory.trackersArray[0])
            
            newCategorie = TrackerCategory(titleOfCategory: trackerCategory.titleOfCategory, trackersArray: trackers)
            categories.append(newCategorie)
            
            newCount = categories[0].trackersArray.count
        }
        
        print("✂️\(oldCount)")
        print("🦷\(newCount)")
        
        let actualDate = datePicker.date.description(with: .current)
        
        showVisibleTrackers(dateDescription: actualDate)
    }
    
    func dismisTrackerTypeController() {
        self.dismiss(animated: true)
    }
}


extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if visibleTrackers.count == 0 {
            collectionView.backgroundColor? = .clear
        } else {
            collectionView.backgroundColor = .ypWhite
        }
        
        return visibleTrackers.isEmpty ? 0 :
        visibleTrackers[section].trackersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.emoji.text = visibleTrackers[indexPath.section].trackersArray[indexPath.row].emoji
        cell.nameLable.text = visibleTrackers[indexPath.section].trackersArray[indexPath.row].name
        cell.view.backgroundColor = visibleTrackers[indexPath.section].trackersArray[indexPath.row].color
        cell.doneButton.backgroundColor = visibleTrackers[indexPath.section].trackersArray[indexPath.row].color
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = headerIdentifier
            
        default:
            id = ""
        }
        
        guard
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView
        else {
                return UICollectionReusableView()
            }
        if 
            id == headerIdentifier,
            !visibleTrackers.isEmpty {
            headerView.titleLabel.text = visibleTrackers[indexPath.section].titleOfCategory
        }
        
        return headerView
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width, height: 18),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}

extension TrackerViewController: UICollectionViewDelegate {
    
}


extension TrackerViewController: UISearchBarDelegate {
    
}


extension TrackerViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController){}
}


extension TrackerViewController: CollectionViewCellDelegate {
    
    func didTapCollectionCellButton(_ cell: CollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        if visibleTrackers[indexPath.section].trackersArray[indexPath.row].schedule.isEmpty {
            
            closeCollectionCellAt(indexPath: indexPath)
        } else {
            cell.shouldAddDay(cell)
        }
        
    }
    
    func closeCollectionCellAt(indexPath: IndexPath){
        
        let cattegorie = categories[indexPath.section]
        let oldVisibleTrackers = visibleTrackers[indexPath.section]
        
        trackers.removeAll()
        
        for tracker in categories[indexPath.section].trackersArray {
            if tracker.id != categories[indexPath.section].trackersArray[indexPath.row].id {
                
                trackers.append(tracker)
            }
        }
        
        categories.remove(at: indexPath.section)
        
        categories.append(TrackerCategory(titleOfCategory: cattegorie.titleOfCategory, trackersArray: trackers))
        
        
        trackers.removeAll()
        
        for tracker in visibleTrackers[indexPath.section].trackersArray {
            if tracker.id != visibleTrackers[indexPath.section].trackersArray[indexPath.row].id {
                
                trackers.append(tracker)
            }
        }
        
        visibleTrackers.remove(at: indexPath.section)
        visibleTrackers.append(TrackerCategory(titleOfCategory: oldVisibleTrackers.titleOfCategory, trackersArray: trackers))
        
        
        collectionView.performBatchUpdates {
            
            collectionView.deleteItems(at: [indexPath])
        }
    }
}
