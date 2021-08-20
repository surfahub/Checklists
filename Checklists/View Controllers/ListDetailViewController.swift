//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Surfa on 02.08.2021.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding item: Checklist)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing item: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    var itemToEdit: Checklist?
    var iconName = "Folder"
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemToEdit = itemToEdit {
            title = "Edit Checklist"
            textField.text = itemToEdit.name
            doneButton.isEnabled = true
            
            iconName = itemToEdit.iconName
            
            
//            if itemToEdit.iconName == "No Icon" {
//                imgView.image = UIImage(named: "Folder")
//            }
//            else {
//                imgView.image = UIImage(named: itemToEdit.iconName)
//            }
            
        }
        imgView.image = UIImage(named: iconName)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        
        if let item = itemToEdit {
            item.name = textField.text!
            item.iconName = iconName
            delegate?.listDetailViewController(self,didFinishEditing: item)
          } else {
            let item = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: item)
          }
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return indexPath.section == 1 ? indexPath : nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "PickIcon" {
        let controller = segue.destination as! IconPickerViewController
        controller.delegate = self
        }
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        itemToEdit?.iconName = iconName
        self.iconName = iconName
        imgView.image = UIImage(named: iconName)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}
