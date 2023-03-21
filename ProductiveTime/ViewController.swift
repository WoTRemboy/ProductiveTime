//
//  ViewController.swift
//  ProductiveTime
//
//  Created by Roman Tverdokhleb on 16.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private var editTitle = ""
    private var editEnable = true
    private var floatingButtonEnable = true
        
    let imageCheck = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .systemGreen]))
    
    let imageCheckSwipe = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemGreen, .white]))
    
    let imageUncheckSwipe = UIImage(
        systemName: "x.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .systemRed]))
    
    let imageUncheck = UIImage(
        systemName: "circle",
        withConfiguration: UIImage.SymbolConfiguration(
            weight: .ultraLight))?
        .withTintColor(.gray, renderingMode: .alwaysOriginal)
    
    
    
    let tableView: UITableView = {
        let table = UITableView()
        
        table.register(TableViewCell.self,
                       forCellReuseIdentifier: "NoImageCell")
        table.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageCell")

        return table
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.setTitleColor(UIColor(red: 52/255,
                                     green: 120/255,
                                     blue: 246/255,
                                     alpha: 0.5),
                                     for: .highlighted)
        
        button.contentHorizontalAlignment = .right
        
        button.addTarget(self, action: #selector(editTapped(sender: )), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 60,
                                            height: 60))
        
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        
        let image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 32,
                weight: .medium))
        
        button.setImage(image, for: .normal)
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    
    
    @objc func didPresentTap(sender: UIButton) {
        
        let vc = SecondViewController()
        
        vc.title = "New Task"
        let navVC = UINavigationController(rootViewController: vc)
        
        // getting info from SecondViewController
        
        vc.completionHandler = { text, fontName, fontSize, alertStatus, alertChanged, dateValue, dateShown, imageValue in
            
            addItem(nameItem: text!,
                    fontName: fontName,
                    fontSize: fontSize,
                    alert: alertStatus,
                    dateValue: dateValue,
                    imageValue: imageValue ?? emptyImageEncoded)
            
            if alertStatus && alertChanged {
                moveItem(fromIndex: toDoItems.endIndex - 1, toIndex: 0)
            }
            
            self.tableView.reloadData()
        }

        present(navVC, animated: true)
    }
    
    @objc func editTapped(sender: UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadData()
        }
    }
    
    // cell button preview function
    
    func imageButtonTapped(in cell: ImageTableViewCell,
                           imageValue: Data) {
        
        let vc = ImagePreviewController()
        
        vc.imageToPreview = imageValue
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create default task if array is empty
        
        if toDoItems.count == 0 {
            
            addItem(nameItem: "Your next task is...",
                    fontName: "Arial",
                    fontSize: 22,
                    imageValue: emptyImageEncoded)
        }
        
        
        title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
                
        tableView.dataSource = self
        tableView.delegate = self
                
        view.addSubview(tableView)
        view.addSubview(floatingButton)
        

        floatingButton.addTarget(self,
                                 action: #selector(didPresentTap(sender: )),
                                 for: .touchUpInside)
        
        floatingButtonSetup()

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        tableViewSetup()
        headerSetup(editTitle: editTitle, editEnable: editEnable)
    }
    
    private func floatingButtonSetup() {
        
        floatingButton.widthAnchor.constraint(
            equalToConstant: 50).isActive = true
        
        floatingButton.heightAnchor.constraint(
            equalToConstant: 50).isActive = true
        
        floatingButton.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor).isActive = true
        
        floatingButton.bottomAnchor.constraint(
            equalTo: self.view.layoutMarginsGuide.bottomAnchor,
            constant: -10).isActive = true
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func headerSetup(editTitle: String, editEnable: Bool) {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width,
                                          height: 30))
        
        countLabel.text = "Is сompleted: \(checkCount ?? -3)"
        editButton.setTitle(editTitle, for: .normal)
        editButton.isHidden = !editEnable

        header.addSubview(countLabel)
        header.addSubview(editButton)

        countLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20).isActive = true
        
        countLabel.widthAnchor.constraint(equalToConstant: header.frame.width/2).isActive = true
        
        countLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        
        
        editButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20).isActive = true
        
        editButton.heightAnchor.constraint(equalTo: header.heightAnchor).isActive = true
        
        editButton.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true

        tableView.tableHeaderView = header

    }
    
    func tableViewSetup() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

}

//  Working with tableView

extension ViewController:  UITableViewDelegate, UITableViewDataSource, ImageTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // to avoid soft lock when deleting the last task in editMode
        
        if toDoItems.count == 1 && tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            tableView.reloadData()
        }
        
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentItem = toDoItems[indexPath.row]
        
        if currentItem["ImageValue"] as? Data == emptyImageEncoded {
            
            // cell without image
            
            guard let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
            else {
                fatalError()
            }
            
            if tableView.isEditing {
                
                editTitle = "Done"
                
                cell.textLabel?.alpha = 0.4
                cell.imageView?.alpha = 0.4
                
                cell.editImageView.alpha = 0.4
                cell.dateLabel.alpha = 0.4
                
                headerSetup(editTitle: editTitle, editEnable: editEnable)
                
                // hiding the floating button the isEditing == true

                if floatingButtonEnable {
                    
                    floatingButton.alpha = 1
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.floatingButton.alpha = 0
                    }) { (finished) in
                        self.floatingButton.isHidden = finished
                    }
                    
                    floatingButtonEnable = false
                }

            } else {
                
                // to avoid editing when only one task remains
                
                if toDoItems.count <= 1 {
                    editEnable = false
                    
                } else {
                    editEnable = true
                }
                
                editTitle = "Edit"
                
                cell.textLabel?.alpha = 1
                cell.imageView?.alpha = 1
                
                cell.editImageView.alpha = 1
                cell.dateLabel.alpha = 1
                
                floatingButton.alpha = 0
                floatingButton.isHidden = false
                
                UIView.animate(withDuration: 0.3) {
                    self.floatingButton.alpha = 1
                }
                floatingButtonEnable = true
                
                headerSetup(editTitle: editTitle, editEnable: editEnable)
            }
                        
            if (currentItem["isCompleted"] as? Bool) == true {
                cell.imageView!.image = imageCheck
                cell.textLabel?.textColor = .lightGray
                

            } else {
                cell.imageView!.image = imageUncheck
                cell.textLabel?.textColor = textColorSet

            }
            
            cell.configure(with: currentItem, index: indexPath.row)
            
            return cell
            
        } else {
            
            // cell with image
            
            guard let cell:ImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell else {
                fatalError()
            }
            
            cell.delegate = self
            
            if tableView.isEditing {
                
                editTitle = "Done"
                
                cell.textLabel?.alpha = 0.4
                cell.imageView?.alpha = 0.4
                
                cell.editImageView.alpha = 0.4
                cell.dateLabel.alpha = 0.4
                
                cell.imageReviewButton.alpha = 0.4
                cell.imageReviewButton.isEnabled = false

                headerSetup(editTitle: editTitle, editEnable: editEnable)

                if floatingButtonEnable {
                    
                    floatingButton.alpha = 1
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.floatingButton.alpha = 0
                    }) { (finished) in
                        self.floatingButton.isHidden = finished
                    }
                    
                    floatingButtonEnable = false
                }

            } else {
                
                if toDoItems.count <= 1 {
                    editEnable = false
                    
                } else {
                    editEnable = true
                }
                
                editTitle = "Edit"
                
                cell.textLabel?.alpha = 1
                cell.imageView?.alpha = 1
                
                cell.editImageView.alpha = 1
                cell.dateLabel.alpha = 1
                
                cell.imageReviewButton.alpha = 1
                cell.imageReviewButton.isEnabled = true
                
                // showing floating button when editing is ended

                floatingButton.alpha = 0
                floatingButton.isHidden = false
                
                UIView.animate(withDuration: 0.3) {
                    self.floatingButton.alpha = 1
                }
                
                floatingButtonEnable = true
                
                headerSetup(editTitle: editTitle, editEnable: editEnable)
            }
            
            if (currentItem["isCompleted"] as? Bool) == true {
                cell.imageView!.image = imageCheck
                cell.textLabel?.textColor = .lightGray
                

            } else {
                cell.imageView!.image = imageUncheck
                cell.textLabel?.textColor = textColorSet

            }
            
            cell.configure(with: currentItem, index: indexPath.row)
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete trailing swipe action
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            tableView.beginUpdates()
            
            let currentItem = toDoItems[indexPath.row]
            
            if (currentItem["isCompleted"] as? Bool) == true {
                
                checkCount -= 1
                self.headerSetup(editTitle: self.editTitle, editEnable: self.editEnable)
            }
            
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if toDoItems.count <= 1 {
                
                self.editEnable = false
                self.headerSetup(editTitle: self.editTitle, editEnable: self.editEnable)
            }
            tableView.endUpdates()

        }
            
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // check leading swipe action
        
        let isChecked = !(toDoItems[indexPath.row]["isCompleted"] as! Bool)
        
        let action = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            
            toDoItems[indexPath.row]["isCompleted"] = (toDoItems[indexPath.row]["isCompleted"] as! Bool)
            completionHandler(true)
            
            
            if changeState(at: indexPath.row) {

                tableView.cellForRow(at: indexPath)?.imageView?.image = self.imageCheck
                tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .lightGray
                
                action.backgroundColor = .green
                action.image = self.imageCheckSwipe
                
                checkCount += 1
                self.headerSetup(editTitle: "Edit", editEnable: self.editEnable)
                
            } else {
                
                tableView.cellForRow(at: indexPath)?.imageView?.image = self.imageUncheck
                tableView.cellForRow(at: indexPath)?.textLabel?.textColor = textColorSet
                
                action.backgroundColor = .red
                checkCount -= 1
                self.headerSetup(editTitle: "Edit", editEnable: self.editEnable)
            }
        }
        
        if isChecked {
            action.backgroundColor = .systemGreen
            action.image = self.imageCheckSwipe
            
        } else {
            action.backgroundColor = .secondarySystemBackground
            action.image = self.imageUncheckSwipe
        }
        
         return UISwipeActionsConfiguration(actions: [action])
     }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let currentItem = toDoItems[sourceIndexPath.row]
        
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(currentItem, at: destinationIndexPath.row)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SecondViewController()
        
        vc.completionHandler = { text, fontName, fontSize, alertStatus, alertChanged, dateValue, dateShown, imageValue in
            
            addItem(nameItem: text!,
                    isCompleted: toDoItems[indexPath.row]["isCompleted"] as! Bool,
                    fontName: fontName,
                    fontSize: fontSize,
                    alert: alertStatus,
                    dateValue: dateValue,
                    imageValue: imageValue!)
            
            removeItem(at: indexPath.row)
            
            if alertStatus && alertChanged {
                moveItem(fromIndex: toDoItems.endIndex - 1, toIndex: 0)
                
            } else if !alertStatus && alertChanged {
                // no movement
            } else {
                moveItem(fromIndex: toDoItems.endIndex - 1, toIndex: indexPath.row)
            }
            
            tableView.reloadData()
            
        }
        
        vc.index = indexPath.row
        
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC, animated: true)
    }
}

