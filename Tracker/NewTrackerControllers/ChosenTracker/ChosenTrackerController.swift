//
//  MakeTrackerController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 14.04.2024.
//

import UIKit

class ChosenTrackerController: UIViewController {
    
    var delegate: ChosenTrackerControllerDelegate?
    
    private let titleLabel = UILabel()
    private let limitWarningLabel = UILabel()
    private let tableView = UITableView()
    private let textField = UITextField()
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    private let buttonsContainer = UIView()
    private let clearTextFieldButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var tableViewCells: [String] = []
    private var warningLabelConstraints: [NSLayoutConstraint] = []
    
    private var nameOfCategory: String?
    private var nameOfTracker: String?
    private var colorOfTracker: UIColor?
    private var emojiOfTracker: String?
    private var scheduleOfTracker: [String] = []
    
    private var newTracker: Tracker?
    
    private let params = GeomitricParams(cellCount: 6, leftInset: 18, rightInset: 18, cellSpacing: 5)
    private let emojiCellIdentifier = "emojiCollectioCell"
    private let colorCellIdentifier = "colorCollectioCell"
    private let reuseHeaderIdentifier = "emojiColectionHeader"
    
    private let emojisArray: [String] = ["🙂", "😻", "🐶", "🌺", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private let colorsArray: [UIColor] = [.red, .orange, .blue, .purple, .green, .ypCyan, .ypLightPink, .ypMediumLightBlue, .ypLightGreen, .ypBlueMagneta, .ypTomato, .ypPink, .ypWarmYellow, .ypBlue, .ypDarkViolet, .ypMediumDarkViolet, .violet, .ypMediumLighGreen]
    
    private var chosenColorCell: UICollectionViewCell?
    private var chosenEmojiCell: UICollectionViewCell?
    
    func configureCollectionUnder(tableView: UITableView, of viewController: UIViewController){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 460),
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            collectionView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor)
        ])
        
        registerCollectionViewsSubviews()
    }
    
    private func registerCollectionViewsSubviews(){
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
    }
    
    private func configureLimitWarningLabel(){
        
        limitWarningLabel.textColor = .ypRed
        limitWarningLabel.font = UIFont.systemFont(ofSize: 17)
        
        view.addSubview(limitWarningLabel)
        limitWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        warningLabelConstraints.append(limitWarningLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor))
        
        warningLabelConstraints.first?.isActive = true
        limitWarningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func configureSaveAndCancelButtons(){
        buttonsContainer.backgroundColor = .ypWhite
        
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
        
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([buttonsContainer, saveButton, cancelButton])
        
        NSLayoutConstraint.activate([
            buttonsContainer.heightAnchor.constraint(equalToConstant: 70),
            buttonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            saveButton.widthAnchor.constraint(equalToConstant: 161),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: buttonsContainer.centerXAnchor, constant: 4),
            saveButton.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: buttonsContainer.centerXAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor)
        ])
    }
    
    private func configureTitleLabelView(){
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([titleLabel])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureTextFieldAndClearButton(){
        
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
            tableView.topAnchor.constraint(equalTo: limitWarningLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        if tableViewCells.count == 2 {
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 149).isActive = true
        } else {
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 74).isActive = true
        }
    }
    
    private func configureEmojiCollection(){
//        self.configureCollectionUnder(tableView: tableView, of: self)
        
        let emojiCollectionPresenter = EmojiCollectionPresenter()
        
        emojiCollectionPresenter.awakeFromNib()
        emojiCollectionPresenter.viewDidLoad()
        emojiCollectionPresenter.configureCollectionUnder(tableView: tableView, of: self)
    }
    
    private func highLightButton(){
        
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
    
    private func setDefaultPositionOfLimitWarningLabel(){
        view.insertSubview(textField, aboveSubview: limitWarningLabel)
    }
    
    private func showLimitWarningLabel(with text: String){
        
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
    
    private func isTextFieldAndSaveButtonEnabled(bool: Bool){
        saveButton.isEnabled = bool
        textField.isEnabled = bool
    }
    
    private func shouldActivateSaveButton(){
        
        if tableViewCells.count > 1 {
            guard !scheduleOfTracker.isEmpty else { return }
        }
        
        guard 
            nameOfTracker  != nil,
            nameOfCategory != nil,
            emojiOfTracker != nil,
            colorOfTracker != nil
        else {
            
            saveButton.backgroundColor = .ypDarkGray
            return
        }
        
        saveButton.backgroundColor = .ypBlack
    }
    
    private func deselectPreviousColor(of collectionView: UICollectionView){
        
            guard let previousColorCell = chosenColorCell,
                  let previousColorIndex = collectionView.indexPath(for: previousColorCell)
            else {
                return
            }
            
            collectionView.deselectItem(at: previousColorIndex, animated: true)
            chosenColorCell?.layer.borderWidth = 0
            chosenColorCell?.backgroundColor = .clear
    }
    
    private func deselectPreviousEmoji(of collectionView: UICollectionView){
        
            guard let previousColorCell = chosenEmojiCell,
                  let previousEmojiIndex = collectionView.indexPath(for: previousColorCell)
            else {
                return
            }
        
            collectionView.deselectItem(at: previousEmojiIndex, animated: true)
            chosenEmojiCell?.backgroundColor = .clear
    }
    
    func configureTwoTableVeiwCells(){
        tableViewCells.append("Категория")
        tableViewCells.append("Рассписание")
    }
    
    func configureOneTableVeiwCell(){
        tableViewCells.append("Категория")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureTitleLabelView()
        configureTextFieldAndClearButton()
        configureLimitWarningLabel()
        configureTableView()
        configureEmojiCollection()
        configureSaveAndCancelButtons()
        
        setDefaultPositionOfLimitWarningLabel()
    }
    
    @objc func didEnterTextInTextField(_ sender: UITextField){
        
        guard
            let text = sender.text,
            !text.isEmpty,
            !text.filter({ $0 != Character(" ") }).isEmpty
        else {
            nameOfTracker = nil
            clearTextFieldButtonTapped()
            shouldActivateSaveButton()
            return
        }
        
        textField.text = text.trimmingCharacters(in: .whitespaces)
        nameOfTracker = text.trimmingCharacters(in: .whitespaces)
        
        shouldActivateSaveButton()
    }
    
    @objc func clearTextFieldButtonTapped(){
        textField.text?.removeAll()
    }
    
    @objc func saveButtonTapped(){
        
        if tableViewCells.count == 2 {
            guard !scheduleOfTracker.isEmpty else {
                showLimitWarningLabel(with: "Заполните все поля")
                highLightButton()
                return
            }
        }
        
        guard
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


extension ChosenTrackerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.backgroundColor = .ypLightGray
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = tableViewCells[indexPath.row]
        
        cell.separatorInset = UIEdgeInsets(top: 0.3, left: 16, bottom: 0.3, right: 16)
        
        return cell
    }
}


extension ChosenTrackerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            let viewControler = CategoryOfTracker()
            viewControler.delegate = self
            
            present(viewControler, animated: true)
        }
        
        if indexPath.row == 1 {
            
            let viewControler = ScheduleOfTracker()
            viewControler.delegate = self
            
            present(viewControler, animated: true)
        }
    }
}


extension ChosenTrackerController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 38
        let currentString = (textField.text ?? "") as NSString
        
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        guard newString.count <= maxLength else {
            
            while var text = textField.text,
                  text.count >= maxLength {
                
                text.removeLast()
                textField.text = text
            }
            
            showLimitWarningLabel(with: "Ограничение 38 символов")
            return false
        }
        
        return true
    }
}


extension ChosenTrackerController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count: Int
        
        if section == 0 {
            count = emojisArray.count
            collectionView.register(EmojiPresenterCell.self, forCellWithReuseIdentifier: emojiCellIdentifier)
            
        } else {
            collectionView.register(ColorCollectionCell.self, forCellWithReuseIdentifier: colorCellIdentifier)
            
            count = colorsArray.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiCellIdentifier, for: indexPath) as? EmojiPresenterCell else {
                return UICollectionViewCell()
            }
            
            cell.cellLabel.text = emojisArray[indexPath.row]
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCellIdentifier, for: indexPath) as? ColorCollectionCell else {
                return UICollectionViewCell()
            }
            
            cell.colorCell.backgroundColor = colorsArray[indexPath.row]
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            
            return cell
        }
    }
}

extension ChosenTrackerController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 {
            deselectPreviousEmoji(of: collectionView)
        } else {
            deselectPreviousColor(of: collectionView)
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .ypLightGray
        
        if indexPath.section == 0 {
            chosenEmojiCell = cell
            emojiOfTracker = emojisArray[indexPath.row]
            
        } else {
            chosenColorCell = cell
            colorOfTracker = colorsArray[indexPath.row]
        }
        
        if indexPath.section == 1 {
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = colorsArray[indexPath.row].withAlphaComponent(0.4).cgColor
        }
        
        shouldActivateSaveButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .clear
        cell?.layer.borderWidth = 0
        
        if indexPath.section == 0 {
            emojiOfTracker = nil
        } else {
            colorOfTracker = nil
        }
        
        shouldActivateSaveButton()
    }
}

extension ChosenTrackerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: params.leftInset, bottom: 16, right: params.rightInset)
    }
}


extension ChosenTrackerController: ScheduleOfTrackerDelegate {
    func didRecieveDatesArray(dates: [String]) {
        
        self.scheduleOfTracker = dates
        shouldActivateSaveButton()
    }
}


extension ChosenTrackerController: CategoryOfTrackerDelegate{
    func didChooseCategory(_ category: String) {
        
        nameOfCategory = category
        shouldActivateSaveButton()
    }
}
