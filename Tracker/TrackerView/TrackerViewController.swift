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
    private lazy var centralPlugLabel = UILabel()
    private lazy var centralPlugImage = UIImageView()
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var trackerStore: TrackerStoreProtocol?
    private var trackerRecordStore: RecordStoreProtocol?
    private var categories: [TrackerCategory] = []
    private var visibleTrackers: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var trackers: [Tracker] = []
    private var records: [Date] = []
    private var currentDate: Date?
    
    private let cellIdentifier = "collectionCell"
    private let headerIdentifier = "headerIdentifier"
    
    private let params = GeomitricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 7)
    
    private var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.calendar = .current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }
    
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.init()
            return
        }
        self.init(appDelegate: appDelegate)
    }
    
    private init(appDelegate: AppDelegate) {
        super.init(nibName: nil, bundle: nil)
        trackerStore = TrackerStore(self, appDelegate: appDelegate)
        trackerRecordStore = TrackerRecordStore(self, appDelegate: appDelegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        datePicker.calendar = .current
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func configureTrackerLabelsViews(){
        centralPlugLabel.text = "Что будем отслеживать?"
        centralPlugLabel.font = UIFont.systemFont(ofSize: 12)
        centralPlugLabel.textAlignment = .center
        
        centralPlugLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([centralPlugLabel])
        
        NSLayoutConstraint.activate([
            centralPlugLabel.widthAnchor.constraint(equalToConstant: 150),
            centralPlugLabel.heightAnchor.constraint(equalToConstant: 18),
            centralPlugLabel.topAnchor.constraint(equalTo: centralPlugImage.bottomAnchor, constant: 8),
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
            centralPlugImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ])
    }
    
    private func configureSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.placeholder = "Поиск"
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.layer.cornerRadius = 8
        searchController.searchBar.layer.masksToBounds = true
        searchController.searchBar.isTranslucent = false
        
        addTitleAndSearchControllerToNavBar()
    }
    
    private func addTitleAndSearchControllerToNavBar(){
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
    
    private func configureCell(for cell: CollectionViewCell, with indexPath: IndexPath){
        
        let actualTracker = visibleTrackers[indexPath.section].trackersArray[indexPath.row]
        
        cell.delegate = self
        cell.idOfCell = actualTracker.id
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
        let viewController = TrackerTypeController(delegate: self)
        
        present(viewController, animated: true)
    }
    
    private func showVisibleTrackers(dateDescription: String){
        
        checkForVisibleTrackersAt(dateDescription: dateDescription)
        collectionView.reloadData()
    }
    
    private func checkForVisibleTrackersAt(dateDescription: String) {
        
        visibleTrackers.removeAll()
        
        var selectedDate: String = ""
        
        for char in dateDescription {
            if char != "," {
                selectedDate.append(char)
            } else {
                break
            }
        }
        
        for category in categories {
            
            trackers.removeAll()
            
            for tracker in category.trackersArray {
                
                if !tracker.schedule.isEmpty {
                    for date in tracker.schedule {
                        
                        if let date, date == selectedDate {
                            
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
    
    private func wasCellButtonTapped(at indexPath: IndexPath) -> Bool {
        
        guard
            let currentDate,
            let actualDate = currentDate.getDefaultDateWith(formatter: dateFormatter)
        else {
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
        
        currentDate = datePicker.date
        configureTrackerViews()
        
        if completedTrackers.isEmpty, let trackerRecordStore {
            completedTrackers = trackerRecordStore.fetchAllConvertedRecords()
        }
        
        if categories.isEmpty, let trackerStore {
            categories = trackerStore.updateCategoriesArray() ?? []
            showVisibleTrackers(dateDescription: datePicker.date.description(with: .current))
        }
    }
    
    
    @objc func didTapPlusButton(){
        
        presentCreatingTrackerView()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        currentDate = sender.date
        showVisibleTrackers(dateDescription: sender.date.description(with: .current))
    }
}


extension TrackerViewController: TrackerViewControllerDelegate {
    
    func addNewTracker(trackerCategory: TrackerCategory) {
        
        self.dismiss(animated: true)
        
        trackerStore?.storeNewTracker(trackerCategory.trackersArray[0], for: trackerCategory.titleOfCategory)
    }
    
    func dismisTrackerTypeController() {
        self.dismiss(animated: true)
    }
}


extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if visibleTrackers.isEmpty {
            collectionView.backgroundColor? = .clear
        } else {
            collectionView.backgroundColor = .ypWhite
        }
        
        return visibleTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView else {
            return UICollectionReusableView()
        }
        
        if id == headerIdentifier,
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

extension TrackerViewController: CollectionViewCellDelegate {
    
    func didTapCollectionCellButton(_ cell: CollectionViewCell) {
        
        guard
            let indexPath = collectionView.indexPath(for: cell),
            let currentDate,
            let actualDate = currentDate.getDefaultDateWith(formatter: dateFormatter)
        else {
            return
        }
        
        let idOfCell = visibleTrackers[indexPath.section].trackersArray[indexPath.row].id
        
        if visibleTrackers[indexPath.section].trackersArray[indexPath.row].schedule.isEmpty {
            
            guard cell.shouldTapButton(cell, date: actualDate) != nil else { return }
            
            trackerStore?.deleteTrackerWith(id: idOfCell)
        } else {
            
            guard let bool = cell.shouldTapButton(cell, date: actualDate) else { return }
            
            shouldRecordDate(bool, idOfCell: idOfCell)
        }
        
    }
    
    private func closeCollectionCellAt(idOfCell: UUID){
        
        let cells = collectionView.visibleCells as? [CollectionViewCell]
        
        guard
            let cell = cells?.first(where: { $0.idOfCell == idOfCell }),
            let indexPath = collectionView.indexPath(for: cell)
        else {
            return
        }
        
        let cattegorie = categories[indexPath.section]
        
        trackers.removeAll()
        
        if cattegorie.trackersArray.count != 1 {
            for tracker in cattegorie.trackersArray {
                if tracker.id != idOfCell {
                    
                    trackers.append(tracker)
                }
            }
            
            categories[indexPath.section] = TrackerCategory(titleOfCategory: cattegorie.titleOfCategory, trackersArray: trackers)
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
    
    private func shouldRecordDate(_ bool: Bool, idOfCell: UUID){
        
        guard 
            let currentDate,
                let actualDate = currentDate.getDefaultDateWith(formatter: dateFormatter)
        else {
            return
        }
        
        records.removeAll()
        
        if bool == true {
            
            addRecordDate(id: idOfCell, actualDate: actualDate)
        } else {
            
            removeRecordDate(for: actualDate, id: idOfCell)
        }
    }
    
    private func addRecordDate(id: UUID, actualDate: Date){
        
        if var dates = completedTrackers.first(where: { $0.id == id })?.date {
            
            dates.append(actualDate)
            trackerRecordStore?.updateRecord(TrackerRecord(id: id, date: dates))
            
        } else {
            
            trackerRecordStore?.storeRecord(TrackerRecord(id: id, date: [actualDate]))
        }
    }
    
    private func removeRecordDate(for actualDate: Date, id: UUID){
        
        records.removeAll()
        
        if let record = completedTrackers.first(where: { $0.id == id }) {
            
            for index in 0..<record.date.count {
                
                if actualDate != record.date[index] {
                    
                    records.append(record.date[index])
                }
            }
            
            trackerRecordStore?.deleteRecord(TrackerRecord(id: id, date: records))
        }
    }
}

extension TrackerViewController: TrackerStoreDelegate {
    
    func didAdd(tracker: Tracker, with categoryTitle: String) {
        
        guard let actualDate = currentDate?.description(with: .current) else { return }
        
        trackers.removeAll()
        
        if categories.contains(where: { category in
            category.titleOfCategory == categoryTitle
        }) {
            for index in 0..<categories.count {
                
                let category = categories[index]
                
                if category.titleOfCategory == categoryTitle {
                    
                    trackers = category.trackersArray
                    trackers.append(tracker)
                    
                    categories[index] = TrackerCategory(titleOfCategory: category.titleOfCategory, trackersArray: trackers)
                }
            }
        } else {
            
            categories.append(TrackerCategory(titleOfCategory: categoryTitle, trackersArray: [tracker]))
        }
        
        showVisibleTrackers(dateDescription: actualDate)
    }
    
    func didDelete(tracker: Tracker) {
        
        closeCollectionCellAt(idOfCell: tracker.id)
    }
    
    func didUpdate(tracker: Tracker) {}
}

extension TrackerViewController: RecordStoreDelegate {
    func didAdd(record: TrackerRecord) {
        
        completedTrackers.append(record)
    }
    
    func didDelete(record: TrackerRecord) {
        
        for index in 0..<completedTrackers.count {
            
            if completedTrackers[index].id == record.id {
                
                completedTrackers.remove(at: index)
                break
            }
        }
    }
    
    func didUpdate(record: TrackerRecord) {
        
        for index in 0..<completedTrackers.count {
            
            if completedTrackers[index].id == record.id {
                
                completedTrackers[index] = record
                break
            }
        }
    }
}

extension TrackerViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController){}
}

extension TrackerViewController: UICollectionViewDelegate {
    
}

extension TrackerViewController: UISearchBarDelegate {
    
}
