//
//  DataModel.swift
//  Checklists
//
//  Created by Surfa on 03.08.2021.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        registerDefaults()
        loadChecklists()
        handleFirstTime()
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(
                forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: "ChecklistIndex")
        }
    }
    
    // MARK: - Data Saving
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // this method is now called saveChecklists()
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            // You encode lists instead of "items"
            let data = try encoder.encode(lists)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    // this method is now called loadChecklists()
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                // You decode to an object of [Checklist] type to lists
                lists = try decoder.decode([Checklist].self,from: data)
                sortChecklists()
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
    class func nextChecklistItemID() -> Int {
      let userDefaults = UserDefaults.standard
      let itemID = userDefaults.integer(forKey: "ChecklistItemID")
      userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
      return itemID
    }

    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1,
        "FirstTime": true ] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    func handleFirstTime() {
      let userDefaults = UserDefaults.standard
      let firstTime = userDefaults.bool(forKey: "FirstTime")

      if firstTime {
        let checklist = Checklist(name: "List")
        lists.append(checklist)
        //saveChecklists()

        indexOfSelectedChecklist = 0
        userDefaults.set(false, forKey: "FirstTime")
      }
    }
    func sortChecklists() {
        
    
        
       // lists.sort { $0.name < $1.name}
        lists.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending}
        
        
//      lists.sort { list1, list2 in
//        return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
      
    }
}
