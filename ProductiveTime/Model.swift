//
//  Model.swift
//  ProductiveTime
//
//  Created by Roman Tverdokhleb on 16.03.2023.
//

import Foundation
import UIKit

private enum SettingsKeys: String {
    case checkCount
}

let buttonBackgroundColor = UIColor(named: "buttonBackgroundColor")

let textColorSet = UIColor(named: "textColor")

let emptyImageEncoded = try! PropertyListEncoder().encode(UIImage(named: "emptyImage")?.jpegData(compressionQuality: 0.1))

let errorImage = UIImage(named: "errorImage")

let fontSizes: [CGFloat] = [10, 12, 15, 18, 20, 22, 25, 28, 30]

var toDoItems: [[String: Any]] {
    get {
        
        if let array = UserDefaults.standard.array(forKey: "ToDoDateKey") as? [[String: Any]] {
            
            return array
            
        } else {
            
            return [["Name": "Your next task is...",
                     "isCompleted": false,
                     "fontName": "Arial",
                     "fontSize": CGFloat(22),
                     "Alert": false,
                     "Date": Date.init(timeIntervalSinceNow: 86400),
                     "ImageValue": emptyImageEncoded]]
        }
    } set {
        UserDefaults.standard.set(newValue, forKey: "ToDoDateKey")
        UserDefaults.standard.synchronize()
    }
}

public var checkCount: Int! {
    get {
        let key = SettingsKeys.checkCount.rawValue
        
        return UserDefaults.standard.integer(forKey: key)
        
    } set {
        
        let defaults = UserDefaults.standard
        let key = SettingsKeys.checkCount.rawValue
        
        if let count = newValue {
            defaults.set(count, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }
}

func addItem(nameItem: String,
             isCompleted: Bool = false,
             fontName: String = "Arial",
             fontSize: CGFloat = 22,
             alert: Bool = false,
             dateValue: Date = Date.init(timeIntervalSinceNow: 86400),
             imageValue: Data?) {
    
    toDoItems.append(["Name": nameItem,
                      "isCompleted": isCompleted,
                      "fontName": fontName,
                      "fontSize": fontSize,
                      "Alert": alert,
                      "Date": dateValue,
                      "ImageValue": imageValue ?? emptyImageEncoded])
}

func removeItem(at index: Int) {
    toDoItems.remove(at: index)
}

func moveItem(fromIndex: Int, toIndex: Int) {
    let from = toDoItems[fromIndex]
    
    toDoItems.remove(at: fromIndex)
    toDoItems.insert(from, at: toIndex)
}

func changeState(at item: Int) -> Bool {
    toDoItems[item]["isCompleted"] = !(toDoItems[item]["isCompleted"] as! Bool)
    
    return toDoItems[item]["isCompleted"] as! Bool
}


