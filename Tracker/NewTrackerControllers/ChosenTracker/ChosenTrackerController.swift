//
//  MakeTrackerController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 14.04.2024.
//

import UIKit

class ChosenTrackerController: UIViewController {
    
    var delegate: ChosenTrackerControllerDelegate?
    
    private let textField = UITextField()
    private let clearTextFieldButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
    private let titleLabel = UILabel()
    private let limitWarningLabel = UILabel()
    private let titleLabelContainer = UIView()
    
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    private let buttonsContainer = UIView()

    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    
    private let tableView = UITableView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let params = GeomitricParams(cellCount: 6, leftInset: 18, rightInset: 18, cellSpacing: 5)
    
    private var tableViewCells: [String] = []
    private var warningLabelBottomConstraint: [NSLayoutConstraint] = []
    
    private var chosenColorCell: UICollectionViewCell?
    private var chosenEmojiCell: UICollectionViewCell?
    
    private var scheduleOfTracker: [String] = []
    private var nameOfCategory: String?
    private var nameOfTracker: String?
    private var colorOfTracker: UIColor?
    private var emojiOfTracker: String?
    
    private let tableCellIdentifier = "tableCellIdentifier"
    private let emojiCellIdentifier = "emojiCollectionCell"
    private let colorCellIdentifier = "colorCollectionCell"
    private let collectionHeaderIdentifier = "collectionHeaderIdentifier"
    
    private let emojisArray: [String] = ["🙂", "😻", "🐶", "🌺", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private let colorsArray: [UIColor] = [.red, .orange, .blue, .purple, .green, .ypCyan, .ypLightPink, .ypMediumLightBlue, .ypLightGreen, .ypBlueMagneta, .ypTomato, .ypPink, .ypWarmYellow, .ypBlue, .ypDarkViolet, .ypMediumDarkViolet, .violet, .ypMediumLightGreen]
    
    
    func vibrancyEffectView(forBlurEffectView blurEffectView:UIVisualEffectView) -> UIVisualEffectView {
            let vibrancy = UIVibrancyEffect(blurEffect: blurEffectView.effect as! UIBlurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancy)
            vibrancyView.frame = blurEffectView.bounds
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return vibrancyView
        }
    
    private func configureScrollView(){
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollContentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -2),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: -2),
            
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -4),
            scrollContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.2)
        ])
    }
    
    private func configureCollection(){
        
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHeaderIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 460),
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            collectionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            
            collectionView.bottomAnchor.constraint(lessThanOrEqualTo: scrollContentView.bottomAnchor)
        ])
    }
    
    private func configureLimitWarningLabel(){
        
        limitWarningLabel.textColor = .ypRed
        limitWarningLabel.font = UIFont.systemFont(ofSize: 17)
        
        view.addSubview(limitWarningLabel)
        limitWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        warningLabelBottomConstraint.append(limitWarningLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor))
        
        warningLabelBottomConstraint.first?.isActive = true
        limitWarningLabel.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor).isActive = true
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
            buttonsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            buttonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            saveButton.widthAnchor.constraint(equalToConstant: 161),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: buttonsContainer.centerXAnchor, constant: 4),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: buttonsContainer.centerXAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTitleLabelView(){
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabelContainer.backgroundColor = .ypWhite
        
        titleLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([titleLabelContainer, titleLabel])
        
        NSLayoutConstraint.activate([
            titleLabelContainer.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabelContainer.bottomAnchor.constraint(equalTo: titleLabelContainer.topAnchor, constant: 63),
            titleLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleLabelContainer.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: titleLabelContainer.centerXAnchor)
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
            textField.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            
            clearTextFieldButton.widthAnchor.constraint(equalToConstant: clearTextFieldButton.frame.width + 12)
        ])
    }
    
    private func configureTableView(){
        tableView.backgroundColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([tableView])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: limitWarningLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16)
        ])
        
        if tableViewCells.count == 2 {
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 149).isActive = true
        } else {
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 74).isActive = true
        }
    }
    
    private func configureEmojiCollection(){
        configureCollection()
        //        let emojiCollectionPresenter = EmojiCollectionPresenter()
        //
        //        emojiCollectionPresenter.awakeFromNib()
        //        emojiCollectionPresenter.viewDidLoad()
        //        emojiCollectionPresenter.configureCollectionUnder(tableView: tableView, of: self)
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
                self.warningLabelBottomConstraint.first?.constant = 30
                self.view.layoutIfNeeded()
                
            } completion: { isCompleted in
                
                UIView.animate(withDuration: 0.3, delay: 1) {
                    self.warningLabelBottomConstraint.first?.constant = 0
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
            guard !scheduleOfTracker.isEmpty else {
                saveButton.backgroundColor = .ypDarkGray
                return
            }
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
        tableViewCells.append("Расписание")
    }
    
    func configureOneTableVeiwCell(){
        tableViewCells.append("Категория")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureScrollView()
        
        configureTextFieldAndClearButton()
        configureLimitWarningLabel()
        configureTableView()
        configureEmojiCollection()
        configureTitleLabelView()
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .ypLightGray
        cell.accessoryType = .disclosureIndicator

        cell.cellText.text = tableViewCells[indexPath.row]
        
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
            viewControler.ifWasCategoryChosenBefore(category: nameOfCategory)
            
            present(viewControler, animated: true)
        }
        
        if indexPath.row == 1 {
            
            let viewControler = ScheduleOfTracker()
            viewControler.delegate = self
            viewControler.IfDatesWasChosenBefore(dates: scheduleOfTracker)
            
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
            collectionView.register(EmojiCollectionCell.self, forCellWithReuseIdentifier: emojiCellIdentifier)
            
        } else {
            collectionView.register(ColorCollectionCell.self, forCellWithReuseIdentifier: colorCellIdentifier)
            
            count = colorsArray.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiCellIdentifier, for: indexPath) as? EmojiCollectionCell else {
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = collectionHeaderIdentifier
        default:
            id = ""
        }
        
        guard
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: id, for: indexPath) as? SupplementaryView
        else {
            return UICollectionReusableView()
        }
        
        if id == collectionHeaderIdentifier {
            if indexPath.section == 0 {
                headerView.titleLabel.text = "Эмодзи"
            } else {
                headerView.titleLabel.text = "Цвет"
            }
        }
        
        return headerView
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
        cell?.backgroundColor = .ypMediumLightGray
        
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
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width, height: 18),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}


extension ChosenTrackerController: ScheduleOfTrackerDelegate {
    func didDismissScreenWithChanges(dates: [String]) {
        scheduleOfTracker = dates
        
        shouldAddDatesOnCellTitle(dates: dates)
        shouldActivateSaveButton()
    }
    
    func didRecieveDatesArray(dates: [String]) {
        scheduleOfTracker = dates
        
        shouldAddDatesOnCellTitle(dates: dates)
        shouldActivateSaveButton()
    }
    
    private func shouldAddDatesOnCellTitle(dates: [String]){
        
        let week: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        let sortedDates = dates.sorted { week.firstIndex(of: $0) ?? 0 < week.firstIndex(of: $1) ?? 1}
        print(dates)
        print(sortedDates)
        let datesString: String = sortedDates.map({ date in
            
            if date == "Monday" {
                return "Пн"
            } else if date == "Tuesday" {
                return "Вт"
            } else if date == "Wednesday" {
                return "Ср"
            } else if date == "Thursday" {
                return "Чт"
            } else if date == "Friday" {
                return "Пт"
            } else if date == "Saturday" {
                return "Сб"
            } else if date == "Sunday" {
                return "Вс"
            }
            
            return ""
        }).joined(separator: ", ")
        
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TableViewCell
        cell?.updateTextOfCellWith(name: tableViewCells[1], text: datesString)
    }
}


extension ChosenTrackerController: CategoryOfTrackerDelegate{
    func didDismissScreenWithChangesIn(_ category: String?) {
        
        nameOfCategory = category
        
        shouldAddCategoryOnCellTitle(category: category)
        shouldActivateSaveButton()
    }
    
    func didChooseCategory(_ category: String) {
        
        nameOfCategory = category
        
        shouldAddCategoryOnCellTitle(category: category)
        shouldActivateSaveButton()
    }
    
    private func shouldAddCategoryOnCellTitle(category: String?){
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell
        cell?.updateTextOfCellWith(name: tableViewCells[0], text: category ?? "")
    }
}
