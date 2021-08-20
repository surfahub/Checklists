//
//  ItemDetailTableViewController.swift
//  Checklists
//
//  Created by Surfa on 01.08.2021.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var shouldRemindSwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!
    
    var itemToEdit: ChecklistItem?
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            doneButton.isEnabled = true
            shouldRemindSwitch.isOn = itemToEdit.shouldRemind
            datePicker.date = itemToEdit.dueDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self,didFinishEditing: item)
          } else {
            let item = ChecklistItem(text: textField.text!)
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishAdding: item)
          }
    }
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()

      if switchControl.isOn {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {_, _ in
          // do nothing
        }
      }
    }
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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
    
    

}
