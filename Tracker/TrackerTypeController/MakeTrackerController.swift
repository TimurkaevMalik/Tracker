//
//  MakeTrackerController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 14.04.2024.
//

import UIKit

class MakeTrackerController: UIViewController {
    
    private let tableView = UITableView()
    private let textField = UITextField()
    private var clearTextFieldButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
    var savedText: String?
    
    func configureTextField(){
        
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
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            clearTextFieldButton.widthAnchor.constraint(equalToConstant: clearTextFieldButton.frame.width + 12)
        ])
    }
    
    func configureTableView(){
        
        tableView.backgroundColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([tableView])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureTextField()
        configureTableView()
    }
    
    @objc func didEnterTextInTextField(_ sender: UITextField){
        guard
            let text = sender.text,
            !text.isEmpty,
            !text.filter({ $0 != Character(" ") }).isEmpty
        else {
            return
        }
        
        savedText = text.trimmingCharacters(in: .whitespaces)
    }
    
    @objc func clearTextFieldButtonTapped(){
        textField.text?.removeAll()
    }
    
}


extension MakeTrackerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}


extension MakeTrackerController: UITableViewDelegate {
    
}

