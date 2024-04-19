//
//  MakeTrackerController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 14.04.2024.
//

import UIKit

class HabbitTrackerController: UIViewController {
    
    var delegate: HabbitTrackerControllerDelegate?
    
    private let titleLabel = UILabel()
    private let limitWarningLabel = UILabel()
    private let tableView = UITableView()
    private let textField = UITextField()
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    private let clearTextFieldButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
    private let tableViewNames = ["Категория", "Расписание"]
    private var warningLabelConstraints: [NSLayoutConstraint] = []
    
    private var nameOfCategory: String?
    private var nameOfTracker: String?
    private var colorOfTracker: UIColor?
    private var emojiOfTracker: String?
    private var scheduleOfTracker: [Date] = []
    
    private var newTracker: Tracker?
    
    
    
    func configureLimitWarningLabel(){
        
        limitWarningLabel.textColor = .ypRed
        limitWarningLabel.font = UIFont.systemFont(ofSize: 17)
        
        view.addSubview(limitWarningLabel)
        limitWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        warningLabelConstraints.append(limitWarningLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor))
        
        warningLabelConstraints.first?.isActive = true
        limitWarningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureSaveAndCancelButtons(){
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        
        saveButton.setTitle("Создать", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.backgroundColor = .ypDarkGray
        saveButton.layer.cornerRadius = 16
        saveButton.layer.masksToBounds = true
        
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.backgroundColor = .ypWhite
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([saveButton, cancelButton])
        
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 161),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 4),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureTitleLabelView(){
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([titleLabel])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureTextFieldAndClearButton(){
        
        textField.delegate = self
        textField.backgroundColor = UIColor(named: "YPLightGray")
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = "Введите название трекера"
        textField.leftViewMode = .always
        
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.addTarget(self, action: #selector(didEnterTextInTextField(_:)), for: .editingDidEndOnExit)
        textField.rightView = clearTextFieldButton
        textField.rightViewMode = .whileEditing
        
        
        clearTextFieldButton.addTarget(self, action: #selector(clearTextFieldButtonTapped), for: .touchUpInside)
        clearTextFieldButton.backgroundColor = UIColor(named: "YPLightGray")
        clearTextFieldButton.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        clearTextFieldButton.contentHorizontalAlignment = .leading
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([textField])
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            clearTextFieldButton.widthAnchor.constraint(equalToConstant: clearTextFieldButton.frame.width + 12)
        ])
    }
    
    func configureTableView(){
        
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
            tableView.topAnchor.constraint(equalTo: limitWarningLabel.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 150),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func highLightButton(){
        
        UIView.animate(withDuration: 0.2) {
            
            self.saveButton.backgroundColor = .ypRed
            
        } completion: { isCompleted in
            if isCompleted {
                resetButtonColor()
            }
        }
        
        func resetButtonColor(){
            UIView.animate(withDuration: 0.1) {
                self.saveButton.backgroundColor = .ypDarkGray
            }
        }
    }
    
    func setDefaultPositionOfLimitWarningLabel(){
        view.insertSubview(textField, aboveSubview: limitWarningLabel)
        
    }
    
    func showLimitWarningLabel(with text: String){
        
        limitWarningLabel.text = text
        isTextFieldAndSaveButtonEnabled(bool: false)
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.4, delay: 0.09) {
                self.warningLabelConstraints.first?.constant = 30
                self.view.layoutIfNeeded()
                
            } completion: { isCompleted in
                
                UIView.animate(withDuration: 0.3, delay: 1) {
                    self.warningLabelConstraints.first?.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.1, execute: {
            
            self.isTextFieldAndSaveButtonEnabled(bool: true)
        })
    }
    
    func isTextFieldAndSaveButtonEnabled(bool: Bool){
        saveButton.isEnabled = bool
        textField.isEnabled = bool
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureTitleLabelView()
        configureTextFieldAndClearButton()
        configureLimitWarningLabel()
        configureTableView()
        configureSaveAndCancelButtons()
        
        setDefaultPositionOfLimitWarningLabel()
    }
    
    @objc func didEnterTextInTextField(_ sender: UITextField){
        guard
            let text = sender.text,
            !text.isEmpty,
            !text.filter({ $0 != Character(" ") }).isEmpty
        else {
            return
        }
        
        textField.text = text.trimmingCharacters(in: .whitespaces)
        
        nameOfTracker = text.trimmingCharacters(in: .whitespaces)
        colorOfTracker = .orange
        emojiOfTracker = "😎"
    }
    
    @objc func clearTextFieldButtonTapped(){
        textField.text?.removeAll()
    }
    
    @objc func saveButtonTapped(){
        
        guard
            !scheduleOfTracker.isEmpty,
            let nameOfCategory = nameOfCategory,
            let name = nameOfTracker,
            let color = colorOfTracker,
            let emoji = emojiOfTracker
        else {
            showLimitWarningLabel(with: "Заполните все поля")
            highLightButton()
            return
        }
        
        let newTracker = Tracker(id: UUID(), name: name, color: color, emoji: emoji, schedule: scheduleOfTracker)
        
        let newCategory = TrackerCategory(titleOfCategory: nameOfCategory, trackersArray: [newTracker])
        
        delegate?.addNewTracker(trackerCategory: newCategory)
    }
    
    @objc func cancelButtonTapped(){
        delegate?.dismisTrackerTypeController()
    }
    
}


extension HabbitTrackerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.backgroundColor = .ypLightGray
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = tableViewNames[indexPath.row]
        
        cell.separatorInset = UIEdgeInsets(top: 0.3, left: 16, bottom: 0.3, right: 16)
        
        return cell
    }
}


extension HabbitTrackerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            nameOfCategory = "My New Category"
            
            let viewControler = CategoryOfTracker()
            viewControler.delegate = self
            
            present(viewControler, animated: true)
        }
        
        if indexPath.row == 1 {
            
            let viewControler = ScheduleOfTracker()
            viewControler.delegate = self
            
            present(viewControler, animated: true)
        }
        
        print("did select row at \(indexPath)")
    }
}


extension HabbitTrackerController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 38
        let currentString = (textField.text ?? "") as NSString
        
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        guard newString.count <= maxLength else {
            
            showLimitWarningLabel(with: "Ограничение 38 символов")
            return false
        }
        
        return true
    }
}


extension HabbitTrackerController: ScheduleOfTrackerDelegate {
    func didRecieveDatesArray(dates: [Date]) {
        
        self.scheduleOfTracker = dates
        
        print("\(self.scheduleOfTracker) 😘")
    }
}


extension HabbitTrackerController: CategoryOfTrackerDelegate{
    func didChooseCategory(_ category: String) {
        nameOfCategory = category
    }
}
