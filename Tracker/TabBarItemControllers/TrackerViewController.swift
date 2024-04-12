//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 04.04.2024.
//

import UIKit


final class TrackerViewController: UIViewController {
    
    private lazy var plusButton = UIButton()
    private lazy var dateButton = UIButton()
    private lazy var titleLabel = UILabel()
    private lazy var centralPlugLabel = UILabel()
    private lazy var centralPlugImage = UIImageView()
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private let ShowCreatingTrackerViewSegueIdentifier = "ShowCreatingTrackerView"
    
    func configureTrackerButtonsViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        
        plusButton = UIButton.systemButton(with: UIImage(named: "PlusImage") ?? UIImage(), target: self, action: #selector(didTapPlusButton))
        plusButton.tintColor = UIColor(named: "YPBlack")
        
        
        dateButton.backgroundColor = UIColor(named: "YPLightGray")
        dateButton.setTitle("14.12.24", for: .normal)
        dateButton.addTarget(self, action: #selector(didTapDateButton), for: .touchUpInside)
        dateButton.setTitleColor(UIColor(named: "YPBlack"), for: .normal)
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        dateButton.layer.cornerRadius = 8
        dateButton.layer.masksToBounds = true
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([plusButton, dateButton])
        
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            dateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        ])
    }
    
    func configureTrackerLabelsViews(){
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            centralPlugLabel.widthAnchor.constraint(equalToConstant: 150),
            centralPlugLabel.heightAnchor.constraint(equalToConstant: 18),
            centralPlugLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 446),
            centralPlugLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configureCentralPlug(){
        centralPlugImage.image = UIImage(named: "TrackerPlug")
        
        centralPlugImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centralPlugImage)
        
        NSLayoutConstraint.activate([
            centralPlugImage.widthAnchor.constraint(equalToConstant: 80),
            centralPlugImage.heightAnchor.constraint(equalToConstant: 80),
            centralPlugImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centralPlugImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 358)
        ])
    }
    
    func configureSearchController(){
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
            searchController.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 92),
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 11),
            searchController.searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11)
        ])
    }
    
    func configureTrackerViews(){
        configureCentralPlug()
        configureTrackerButtonsViews()
        configureTrackerLabelsViews()
        configureSearchController()
    }
    
    func presentCreatingTrackerView(){
        
        let viewController = CreatingTracker()
        
        viewController.delegate = self
        viewController.modalPresentationStyle = .popover
//        viewController.present
        
        present(viewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowCreatingTrackerViewSegueIdentifier {
            
            let viewController = segue.destination as? CreatingTracker
            
            guard let viewController else {
                return
            }
            
            viewController.delegate = self
            viewController.modalPresentationStyle = .popover
    //        viewController.present
            present(viewController, animated: true)
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
//        performSegue(withIdentifier: ShowCreatingTrackerViewSegueIdentifier, sender: nil)
    }
    
    @objc func didTapDateButton(){
        print("DATE BUTTON")
    }
}


extension TrackerViewController: UISearchBarDelegate {}


extension TrackerViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {}
}


extension TrackerViewController: CreatingTrackerDelegate {
    func CreatingTrackerViewDidDismiss() {
        
        completedTrackers.remove(at: completedTrackers.count - 1)
    }
}
