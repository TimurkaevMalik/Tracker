//
//  ScheduleOfTracker.swift
//  Tracker
//
//  Created by Malik Timurkaev on 19.04.2024.
//

import UIKit


final class ScheduleOfTracker: UIViewController {
    
    private weak var delegate: ScheduleOfTrackerDelegate?
    
    private let doneButton = UIButton()
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    
    private var chosenDates: [String] = []
    private let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    
    init(delegate: ScheduleOfTrackerDelegate,
         wasDatesChosen dates: [String]){
        
        chosenDates = dates
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureDoneButton()
        configureTitleLabelView()
        configureTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.didDismissScreenWithChanges(dates: chosenDates)
    }
    
    @objc func doneButtonTapped(){
        
        guard !chosenDates.isEmpty else {
            highLightButton()
            return
        }
        
        delegate?.didRecieveDatesArray(dates: chosenDates)
        
        dismiss(animated: true)
    }
    
    @objc func switchChanged(_ sender: UISwitch){
        
        var stringWeekDay = ""
        
        switch sender.tag {
        case 0:
            stringWeekDay = "Monday"
        case 1:
            stringWeekDay = "Tuesday"
        case 2:
            stringWeekDay = "Wednesday"
        case 3:
            stringWeekDay = "Thursday"
        case 4:
            stringWeekDay = "Friday"
        case 5:
            stringWeekDay = "Saturday"
        case 6:
            stringWeekDay = "Sunday"
        default:
            return
        }
        
        switch sender.isOn {
        case true:
            chosenDates.append(stringWeekDay)
            
        case false:
            for index in 0..<chosenDates.count {
                
                if chosenDates[index] == stringWeekDay {
                    chosenDates.remove(at: index)
                    break
                }
            }
        }
    }
    
    private func configureTitleLabelView(){
        let titleLabelText = NSLocalizedString("schedule", comment: "Text displayed on the top of screen")
        
        titleLabel.text = titleLabelText
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([tableView])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 524),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDoneButton(){
        let doneButtonTitle = NSLocalizedString("doneButton.title", comment: "Text displayed on done button")
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.setTitle(doneButtonTitle, for: .normal)
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
    
    private func shouldSetSwitchOnForCell(_ indexPath: IndexPath) -> Bool {
        
        for date in chosenDates {
            if date == weekdays[indexPath.row] {
                return true
            }
        }
        
        return false
    }
    
    func locolizedWeekdayOf(_ weekDay: String) -> String? {
        
        var text: String = ""
        
        if weekDay == weekdays[0] {
            text = weekdays[0].lowercased()
            
        } else if weekDay == weekdays[1] {
            text = weekdays[1].lowercased()
            
        } else if weekDay == weekdays[2] {
            text = weekdays[2].lowercased()
            
        } else if weekDay == weekdays[3] {
            text = weekdays[3].lowercased()
            
        } else if weekDay == weekdays[4] {
            text = weekdays[4].lowercased()
            
        } else if weekDay == weekdays[5] {
            text = weekdays[5].lowercased()
            
        } else if weekDay == weekdays[6] {
            text = weekdays[6].lowercased()
        }
        
        return NSLocalizedString(text, comment: "")
    }
}

extension ScheduleOfTracker: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        let switchView = UISwitch(frame: .zero)
        switchView.isOn = shouldSetSwitchOnForCell(indexPath)
        switchView.onTintColor = .ypBlue
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        cell.accessoryView = switchView
        cell.backgroundColor = .ypLightGray
        
        cell.textLabel?.text = locolizedWeekdayOf(weekdays[indexPath.row])
        
        cell.separatorInset = UIEdgeInsets(top: 0.3, left: 16, bottom: 0.3, right: 16)
        
        return cell
    }
}


extension ScheduleOfTracker: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
}
