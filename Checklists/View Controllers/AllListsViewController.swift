//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Surfa on 02.08.2021.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate, ChecklistViewControllerDelegate {
   
    
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.delegate = self
       
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(
                withIdentifier: "ShowChecklist",
                sender: checklist)
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(
          withIdentifier: cellIdentifier) {
          cell = tmp
        } else {
          cell = UITableViewCell(
            style: .subtitle,
            reuseIdentifier: cellIdentifier)
        }
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.imageView!.image = UIImage(named: checklist.iconName)
        cell.accessoryType = .detailDisclosureButton
        
        let count = checklist.countUncheckedItems()
        
        if checklist.items.count == 0 {
          cell.detailTextLabel!.text = "(No Items)"
        } else {
          cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
            controller.delegate = self
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailViewController") as! ListDetailViewController
        
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.itemToEdit = checklist
        navigationController?.pushViewController(controller,animated: true)
    }
    
    // MARK: - Add Checklist ViewController Delegates
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding item: Checklist) {
        
        dataModel.lists.append(item)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing item: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController:
                                UIViewController, animated: Bool) {
        
        //        let alert = UIAlertController(title: "Info", message: "we are here", preferredStyle: .alert)
        //        let alertAction = UIAlertAction(title: "hello", style: .default)
        //        alert.addAction(alertAction)
        //        present(alert, animated: true)
        
        
        // Was the back button tapped?
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    func checklistViewControllerCopy(_ controller: ChecklistViewController, didCopied item: Checklist, withName newName: String) {
        
        let checklist = Checklist(name: newName, iconName: item.iconName)
        checklist.items = item.items
        dataModel.lists.append(checklist)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
   
    
    
}
