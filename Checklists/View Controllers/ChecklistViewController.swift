//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Surfa on 30.07.2021.
//

import UIKit
protocol ChecklistViewControllerDelegate{
    func checklistViewControllerCopy(_ controller: ChecklistViewController, didCopied item: Checklist, withName newName:String)
}

class ChecklistViewController: UITableViewController,  ItemDetailViewControllerDelegate{
    
    
    
    var checklist: Checklist!
    var delegate: ChecklistViewControllerDelegate?
    
    @IBOutlet weak var copyButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        navigationItem.largeTitleDisplayMode = .never
        //loadChecklistItems()
        
       // print("Documents folder is \(documentsDirectory())")
       // print("Data file path is \(dataFilePath())")

       
        
    }
    
    //MARK: -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // MARK: - Table View Delegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
  

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "\(item.text)"
       // label.text = item.text
    }
    
    // MARK: - Add Item ViewController Delegates
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        
        
        
        
        let newRowIndex = checklist.items.count
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        //tableView.insertRows(at: indexPaths, with: .automatic)
        checklist.items.append(item)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
          if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
              configureText(for: cell, with: item)
            }
          }
          navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func copyPressed(_ sender: Any) {
        var textTF = ""
        
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle:.alert)
            alertController.addTextField(configurationHandler:{ (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Name for a new list"
            })
            
        let saveAction = UIAlertAction(title: "OK", style: .default) { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
            textTF = (firstTextField.text! != "") ? firstTextField.text! : self.checklist.name+" copy"
            
            self.delegate?.checklistViewControllerCopy(self, didCopied: self.checklist, withName: textTF)
            }
            
            
            alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
        //print(textTF)
        
            
        
        
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
}

