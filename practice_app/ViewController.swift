//
//  ViewController.swift
//  practice_app
//
//  Created by zed on 09.03.23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    let context = AppDelegate().persistentContainer.viewContext
    var items = [TodoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchItems()
        title = "TO DO LIST"
    }
    
    @IBAction func addItem(_ sender: Any) {
        addAlert()
    }
    
    
    // Update the item in DB
    func updateItem(id: Int64, text: String) {
        for item in items {
            if id == item.id {
                item.title = text
                do {
                    try self.context.save()
                    self.fetchItems()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    // Deletes item from DB
    func deleteItem(id: Int64) {
        for item in items {
            if id == item.id {
                self.context.delete(item)
                // print("we just deleted the itemmmmmm")
                do {
                    try self.context.save()
                    self.fetchItems()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Gets all items from DB
    func fetchItems() {
        do {
            self.items = try self.context.fetch(TodoList.fetchRequest())
            self.table.reloadData()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // Saves item to DB
    func saveItem(text: String) {
        let model = TodoList(context: self.context)
        let newID: Int64? = self.items.last?.id ?? 0
        model.id = newID! + 1
        model.title = text
        
        do {
            try self.context.save()
            self.fetchItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Pops an Alert for adding
    func addAlert() {
        let alertController = UIAlertController(title: "Enter new item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let itemToBeStored = alertController.textFields?[0].text
            self.saveItem(text: itemToBeStored ?? "")
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter your text..."
        }
        
        navigationController?.present(alertController, animated: true)
    }
    
    
    
    // Pops an Alert for updating
    func updateAlert(id: Int64) {
        let alertController = UIAlertController(title: "Enter new item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let updateInfo = alertController.textFields?[0].text ?? ""
            self.updateItem(id: id, text: updateInfo)
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter your text..."
        }
        
        navigationController?.present(alertController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(self.items[indexPath.row].id). \(self.items[indexPath.row].title!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { _, _, _ in
            self.deleteItem(id: self.items[indexPath.row].id)
            self.table.reloadData()
        }
        
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.updateAlert(id: self.items[indexPath.row].id)
            self.table.reloadData()
        }
        
        update.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [update])
    }
    
}

