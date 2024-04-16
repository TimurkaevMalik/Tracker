//
//  MakeTrackerController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 14.04.2024.
//

import UIKit

class HabbitTrackerController: UIViewController {
    
    var delegate: HabbitTrackerControllerProtocol?
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let textField = UITextField()
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    private var clearTextFieldButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    private let tableViewNames = ["Категория", "Расписание"]
    
    var nameOfTracker: String?
    var emojiOfTracker: String?
    var colorOfTracker: UIColor?
    var idOfTracker: UUID?
    var dateOfTracker: Date?
    

    func configureSaveAndCancelButtons(){
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        
        saveButton.setTitle("Создать", for: .normal)
        saveButton.titleLabel?.text = "Создать"
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureTextFieldAndClearButton(){
        
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
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 150),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureTitleLabelView()
        configureTextFieldAndClearButton()
        configureTableView()
        configureSaveAndCancelButtons()
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
        emojiOfTracker = "😘"
        colorOfTracker = .orange
        idOfTracker = UUID()
        dateOfTracker = Date()
        
        print(nameOfTracker!)
    }
    
    @objc func clearTextFieldButtonTapped(){
        textField.text?.removeAll()
    }
    
    @objc func saveButtonTapped(){
        
        guard
            let name = nameOfTracker,
            let emoji = emojiOfTracker,
            let color = colorOfTracker,
            let id = idOfTracker,
            let date = dateOfTracker
        else {
            return
        }
            
        
        let newTracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: date)
        
        delegate?.addNewTracker(tracker: newTracker)
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
        
        print("did select row at \(indexPath)")
    }
}
