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
    private var records: [Date] = []
    
    private let cellIdentifier = "collectionCell"
    private let headerIdentifier = "footerIdentifier"
    
    private let params = GeomitricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 7)
    
    private var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }
    
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
    
    func configureCell(for cell: CollectionViewCell, with indexPath: IndexPath){
        
        let actualTracker = visibleTrackers[indexPath.section].trackersArray[indexPath.row]
        
        cell.delegate = self
        cell.emoji.text = actualTracker.emoji
        cell.nameLable.text = actualTracker.name
        cell.view.backgroundColor = actualTracker.color
        cell.doneButton.backgroundColor = actualTracker.color
        
        
        if wasCellButtonTapped(at: indexPath) == true {
            
            cell.doneButton.backgroundColor = actualTracker.color.withAlphaComponent(0.3)
            cell.doneButton.setImage(UIImage(named: "CheckMark"), for: .normal)
        } else {
            
            cell.doneButton.backgroundColor = actualTracker.color.withAlphaComponent(1)
            cell.doneButton.setImage(UIImage(named: "WhitePlus"), for: .normal)
        }
        
        
        if !completedTrackers.isEmpty {
            
            for record in completedTrackers {
                if record.id == actualTracker.id {
                    
                    print(record.date.count)
                    cell.count = record.date.count
                    cell.daysCount.text = "\(record.date.count) день"
                } else {
                    
                    if completedTrackers.contains(where: { element in
                        element.id == actualTracker.id
                    }) {
                        
                        continue
                    } else {
                        
                        cell.daysCount.text = "0 дней"
                        cell.count = 0
                    }
                }
            }
        } else {
            cell.daysCount.text = "0 дней"
            cell.count = 0
        }
    }
    
    private func presentCreatingTrackerView(){
        
        let viewController = TrackerTypeController()
        viewController.delegate = self
        
        present(viewController, animated: true)
    }
    
    private func showVisibleTrackers(dateDescription: String){
        
        checkForVisibleTrackersAt(dateDescription: dateDescription)
        
        print(visibleTrackers)
        collectionView.reloadData()
    }
    
    func checkForVisibleTrackersAt(dateDescription: String) {
        
        visibleTrackers.removeAll()
        print(visibleTrackers.isEmpty)
        
        var selectedDate: String = ""
        
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
            if !trackers.isEmpty {
                visibleTrackers.append(TrackerCategory(titleOfCategory: category.titleOfCategory, trackersArray: trackers))
            }
        }
    }
    
    func wasCellButtonTapped(at indexPath: IndexPath) -> Bool {
        
        guard let actualDate = datePicker.date.getDefaultDateWith(formatter: dateFormatter) else {
            return false
        }
        
        let id = visibleTrackers[indexPath.section].trackersArray[indexPath.row].id
        
        for element in completedTrackers {
            
            if element.id == id {
                for date in element.date {
                    
                    if actualDate == date {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTrackerViews()
    }
    
    
    @objc func didTapPlusButton(){
        
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
        
        if visibleTrackers.isEmpty {
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
        
        configureCell(for: cell, with: indexPath)
        
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
        let idOfCell = visibleTrackers[indexPath.section].trackersArray[indexPath.row].id
        
        
        if visibleTrackers[indexPath.section].trackersArray[indexPath.row].schedule.isEmpty {
            
            closeCollectionCellAt(indexPath: indexPath, idOfCell: idOfCell)
        } else {
            
            guard let bool = cell.shouldAddDay(cell) else { return }
            shouldRecordDate(bool, idOfCell: idOfCell)
        }
        
    }
    
    func closeCollectionCellAt(indexPath: IndexPath, idOfCell: UUID){
        
        let cattegorie = categories[indexPath.section]
        
        trackers.removeAll()
        
        if cattegorie.trackersArray.count != 1 {
            for tracker in cattegorie.trackersArray {
                if tracker.id != idOfCell {
                    
                    trackers.append(tracker)
                }
            }
            categories.remove(at: indexPath.section)
            
            categories.append(TrackerCategory(titleOfCategory: cattegorie.titleOfCategory, trackersArray: trackers))
        } else {
            categories.remove(at: indexPath.section)
        }
        
        
        checkForVisibleTrackersAt(dateDescription: datePicker.date.description(with: .current))
        
        collectionView.performBatchUpdates {
            
            collectionView.deleteItems(at: [indexPath])
        }
        
        if visibleTrackers.isEmpty {
            collectionView.backgroundColor = .clear
        }
    }
    
    
    func shouldRecordDate(_ bool: Bool, idOfCell: UUID){
        
        guard let actualDate = datePicker.date.getDefaultDateWith(formatter: dateFormatter) else {
            return
        }
        
        print("✅\(actualDate)")
        
        records.removeAll()
        
        if bool == true {
            
            addRecordDate(id: idOfCell, actualDate: actualDate)
        } else {
            
            removeRecordDate(id: idOfCell, actualDate: actualDate)
        }
        print(completedTrackers)
    }
    
    
    func addRecordDate(id: UUID, actualDate: Date){
        
        if !completedTrackers.isEmpty {
            
            if completedTrackers.contains(where: { element in
                element.id == id
            }) {
                
                for index in 0..<completedTrackers.count {
                    if completedTrackers[index].id == id {
                        
                        records = completedTrackers[index].date
                        records.append(actualDate)
                        
                        completedTrackers.remove(at: index)
                        completedTrackers.append(TrackerRecord(id: id, date: records))
                        break
                    }
                }
            } else {
                
                completedTrackers.append(TrackerRecord(id: id, date: [actualDate]))
            }
        } else {
            completedTrackers.append(TrackerRecord(id: id, date: [actualDate]))
        }
    }
    
    func removeRecordDate(id: UUID, actualDate: Date){
        
        for index in (0..<completedTrackers.count).reversed() {
            
            let recordToCheck = completedTrackers[index]
            
            if id == recordToCheck.id {
                
                if recordToCheck.date.count != 1 {
                    
                    for dateIndex in 0..<recordToCheck.date.count {
                        
                        if actualDate != recordToCheck.date[dateIndex] {
                            
                            records.append(recordToCheck.date[dateIndex])
                        }
                    }
                    
                    completedTrackers.remove(at: index)
                    completedTrackers.append(TrackerRecord(id: id, date: records))
                } else {
                    
                    completedTrackers.remove(at: index)
                }
            } else {
                print("id is not equal to recordToCheck.id")
            }
        }
    }
}
