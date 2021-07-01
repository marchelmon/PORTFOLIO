//
//  ViewController.swift
//  task-tracker
//
//  Created by marchelmon on 2021-06-06.
//

import UIKit

private let cellIdentifier = "TodoItemCell"

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var categoryIndex: Int = 0
    
    var category: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
        
    }

    
    //MARK: - Actions
    
    func loadItems() {
        guard let items = category?.items else { return }
        itemArray = items
        tableView.reloadData()
    }
    
    
    //MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        return cell
    }

    //MARK: - TableViewDelegate
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
                
        Service.shared.categories[categoryIndex].items = itemArray
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if alertTextField.text == "" { return }
            let newItem = Item(title: alertTextField.text!, done: false)
            self.itemArray.append(newItem)
            Service.shared.categories[self.categoryIndex].items.append(newItem)
            self.tableView.reloadData()
        }
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Task name.."
            alertTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}



