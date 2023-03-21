//
//  SecondViewController.swift
//  ProductiveTime
//
//  Created by Roman Tverdokhleb on 16.03.2023.
//

import UIKit

class SecondViewController: UIViewController, UITextViewDelegate {
    
    public var index = -3
    public var imageValue: Data? = emptyImageEncoded
    
    public var completionHandler: ((String?, String, CGFloat, Bool, Bool, Date, Bool, Data?) -> Void)?
    
    
    private  var taskText = ""
    
    private var fontSizeNumber: CGFloat = 22
    private var fontName = "Arial"
    
    private var alertStatus = false
    private var alertFirst = false
    
    private var dateValue: Date = Date.init(
        timeIntervalSinceNow: 86400)
    
    private let dateValueOriginal: Date = Date.init(timeIntervalSinceNow: 86400)
    
    
    private let taskTextPlaceholder = "Your next task is..."
    
    private var dateHasChanged = false
    private var alertChanged = false
    
    let imageAlert = UIImage(
        systemName: "exclamationmark.circle",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .systemRed]))
    
    let imagePhoto = UIImage(systemName: "photo")
    
    let imagePhotoSelected = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(
        paletteColors: [.orange]))
    
    let pickerView = UIPickerView()
    
    let items = [UIImage(
        systemName: "flag",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemBlue, .systemBlue])),
                 UIImage(
        systemName: "flag.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemRed, .systemRed]))]
    
    lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: items as [Any])
        
        view.addTarget(self,
                       action: #selector(alertToChange),
                       for: .valueChanged)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = buttonBackgroundColor
        
        return view
    }()
    
    private let taskField: UITextView = {
        let field = UITextView()
        field.textColor = .lightGray
        field.textAlignment = .left
        field.font = .systemFont(ofSize: 22, weight: .regular)
        field.layer.cornerRadius = 10
        field.backgroundColor = buttonBackgroundColor
        
        field.contentInset = UIEdgeInsets(top: 10,
                                          left: 10,
                                          bottom: 10,
                                          right: 10)
        field.clipsToBounds = true
        
        field.translatesAutoresizingMaskIntoConstraints = false
                
        return field
    }()
    
    private let datePickerField: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .systemBlue
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let changeFontButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Pick Font",
                        for: .normal)
        
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = 15
        button.setTitleColor(textColorSet, for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), for: .highlighted)
        
        button.addTarget(self,
                         action: #selector(changeFontButtonPressed),
                         for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let fontSizeField: TextField = {
        let field = TextField()
        
        field.backgroundColor = buttonBackgroundColor
        field.layer.cornerRadius = 15
        field.textAlignment = .center
        field.textColor = textColorSet
        
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.inputAccessoryView = accessoryView
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let imageAdd: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = 15
        
        button.addTarget(self,
                         action: #selector(imageAddPressed),
                         for: .touchUpInside)
        
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Accept",
                        for: .normal)
        
        
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = 15
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.setTitleColor(UIColor(red: 52/255,
                                     green: 120/255,
                                     blue: 246/255,
                                     alpha: 0.5),
                             for: .highlighted)
        
        button.addTarget(self,
                         action: #selector(acceptButtonPressed),
                         for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Cancel",
                        for: .normal)
        
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = 15
        button.setTitleColor(.systemRed, for: .normal)
        
        button.setTitleColor(UIColor(red: 235/255,
                                     green: 78/255,
                                     blue: 61/255,
                                     alpha: 0.5),
                             for: .highlighted)
        
        button.addTarget(self,
                         action: #selector(cancelButtonPressed),
                         for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func changeFontButtonPressed(selector: UIButton) {
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = false
        
        let vc = UIFontPickerViewController(configuration: config)
        vc.delegate = self
        
        present(vc, animated: true)
    }
    
    @objc func acceptButtonPressed(selector: UIButton) {
        
        if taskField.hasText && taskField.text != taskTextPlaceholder {
            
            // is textField has any text to save
            
            if datePickerField.date.compare(Date.now) == .orderedAscending {
                
                // date is no longer present or future
                
                let title = "Date is illigal!"
                let message = "Please, enter your target date"
                
                let alertController1 =
                            UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                
                let alertAction1 = UIAlertAction(title: "OK",
                                                style: .cancel)
                
                alertController1.addAction(alertAction1)
                view.endEditing(true)
                
                present(alertController1, animated: true)
                
            } else {
                
                guard let fontName = taskField.font?.fontName else { return }
                guard let fontSize = taskField.font?.pointSize else { return }
                
                if alertStatus == alertFirst {
                    
                // check: is it needed to move task to first or last place
                    
                    alertChanged = false
                } else {
                    alertChanged = true
                }
                
                dateValue = datePickerField.date

                completionHandler?(taskField.text, fontName, fontSize, alertStatus, alertChanged, dateValue, dateHasChanged, imageValue)

                dismiss(animated: true)
            }
            
        } else {
            
            // trying to save empty taskField
            
            let title = "Empty field"
            let message = "Please, enter your next task"
            let alertController =
                        UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK",
                                            style: .cancel)
            
            alertController.addAction(alertAction)
            view.endEditing(true)
            
            present(alertController, animated: true)
        }
        
    }
    
    @objc func cancelButtonPressed(selector: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func alertToChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            alertStatus = false
        case 1:
            alertStatus = true
        default:
            alertStatus = false
        }
    }
    
    @objc func imageAddPressed(sender: UIButton) {
        
        if imageAdd.currentImage == imagePhoto {
            
            // first time button is pressed (no attached image)
            
            let vc = UIImagePickerController()
            
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            
            present(vc, animated: true)
            
        } else {
            
            // image has already attached to the task
            
            let vc = ImagePreviewController()
            
            vc.imageToPreview = imageValue
            let navVC = UINavigationController(rootViewController: vc)
            
            present(navVC, animated: true)
        }
        
    }
    
    private func elementsInit(at index: Int) {
        
        // local variables take values ​​from public data
        
        title = "Edit Task"
        
        let currentItem = toDoItems[index]
        
        taskText = currentItem["Name"] as! String
        fontName = currentItem["fontName"] as! String
        fontSizeNumber = currentItem["fontSize"] as! CGFloat
        alertStatus = currentItem["Alert"] as! Bool
        dateValue = currentItem["Date"] as! Date
        imageValue = currentItem["ImageValue"] as? Data
        alertFirst = alertStatus
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if index != -3 {
            
            // means task is not "New"
            
            elementsInit(at: index)
        }
        
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(taskField)
        view.addSubview(changeFontButton)
        view.addSubview(fontSizeField)
        view.addSubview(imageAdd)
        view.addSubview(segmentedControl)
        view.addSubview(datePickerField)
        view.addSubview(acceptButton)
        view.addSubview(cancelButton)
        
        taskField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        taskFieldSetup()
        segmentedControlSetup()
        datePickFieldSetup()
        changeFontButtonSetup()
        fontSizeFieldSetup()
        imageAddSetup()
        cancelButtonSetup()
        acceptButtonSetup()
        

        pickerView.selectRow(fontSizes.firstIndex(of: fontSizeNumber)!, inComponent: 0, animated: false)
    }
    
    private func taskFieldSetup() {
        
        taskField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        
        taskField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        taskField.heightAnchor.constraint(equalToConstant: view.frame.height/4).isActive = true
        
        taskField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/12).isActive = true
        
        if taskText.isEmpty || taskText == taskTextPlaceholder {
            taskField.text = taskTextPlaceholder
            
        } else {
            taskField.text = taskText
            taskField.textColor = textColorSet
        }
        
        taskField.font = UIFont(name: fontName, size: fontSizeNumber)
    }
    
    private func datePickFieldSetup() {
        
        datePickerField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        
        datePickerField.topAnchor.constraint(equalTo: taskField.bottomAnchor, constant: 30).isActive = true
        
        datePickerField.heightAnchor.constraint(equalTo: segmentedControl.heightAnchor).isActive = true
        
        datePickerField.date = dateValue
        
        if title == "New Task" {
            datePickerField.minimumDate = .now
        }
    }
    
    private func fontSizeFieldSetup() {
        
        fontSizeField.trailingAnchor.constraint(equalTo: imageAdd.leadingAnchor, constant: -20).isActive = true
        
        fontSizeField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        
        fontSizeField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        fontSizeField.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        fontSizeField.text = String(format: "%.0f", fontSizeNumber)
        fontSizeField.inputView = pickerView
    
    }
    
    
    private func changeFontButtonSetup() {
        
        changeFontButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        changeFontButton.trailingAnchor.constraint(equalTo: fontSizeField.leadingAnchor, constant: -20).isActive = true
        
        changeFontButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        changeFontButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        
    }
    
    private func segmentedControlSetup() {
        
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        segmentedControl.topAnchor.constraint(equalTo: taskField.bottomAnchor, constant: 30).isActive = true
        
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        segmentedControl.trailingAnchor.constraint(equalTo: datePickerField.leadingAnchor, constant: -10).isActive = true

        if alertStatus {
            
            // red flag is selected
            
            segmentedControl.selectedSegmentIndex = 1
        } else {
            
            // blue flag is selected
            
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    
    private func imageAddSetup() {
        
        imageAdd.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        imageAdd.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        
        imageAdd.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        imageAdd.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        if imageValue == nil || imageValue == emptyImageEncoded {
            
            // button is not orange - image isn't attached
            
            imageAdd.setImage(imagePhoto, for: .normal)
        } else {
            
            // button is orange - image is attached
            
            imageAdd.setImage(imagePhotoSelected, for: .normal)
        }
    }
    
    private func acceptButtonSetup() {
        
        acceptButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 20).isActive = true
        
        acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        acceptButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        acceptButton.topAnchor.constraint(equalTo: imageAdd.bottomAnchor, constant: 20).isActive = true
    }
    
    private func cancelButtonSetup() {
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        cancelButton.widthAnchor.constraint(equalToConstant: view.frame.width/4).isActive = true
        
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: imageAdd.bottomAnchor, constant: 20).isActive = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = textColorSet
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = taskTextPlaceholder
            textView.textColor = .lightGray
        }
    }
    
}

// fontSizeField without cursor

class TextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}

// fontPicker extension

extension SecondViewController: UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        
        viewController.dismiss(animated: true)
    }
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        
        taskField.font = UIFont(descriptor: descriptor,
                                size: fontSizeNumber)
        
        guard let font = taskField.font?.fontName else { return }
        fontName = font
        
        viewController.dismiss(animated: true)
    }
}

// picker for fontSize extension

extension SecondViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return fontSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(format: "%.0f", fontSizes[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        fontSizeNumber = fontSizes[row]
        
        fontSizeField.text = String(format: "%.0f", fontSizes[row])
        
        taskField.font = UIFont(name: fontName, size: fontSizeNumber)
        
    }
}

// imagePicker extension

extension SecondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            imageAdd.setImage(imagePhotoSelected, for: .normal)
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            
            let encoded = try! PropertyListEncoder().encode(imageData)
            
            imageValue = encoded

        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
    }
}
