//
//  CategoryListViewController.swift
//  task-tracker
//
//  Created by marchelmon on 2021-06-06.
//

import UIKit

private let cellIdentifier = "CategoryCell"

class CategoryListViewController: UITableViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
        
        let vakna = Item(title: "Vakna", done: true)
        let frukost = Item(title: "Ät frukost", done: true)
        let jobba = Item(title: "Jobba", done: true)
        let lunch = Item(title: "Lunch", done: false)
        let train = Item(title: "träna", done: false)
        let fritid = Item(title: "Fritid", done: false)
        let sov = Item(title: "Sov", done: false)
        
        let pasta = Item(title: "Pasta", done: true)
        let bananer = Item(title: "Bananer", done: true)
        let onion = Item(title: "Lök", done: false)
        let ketchup = Item(title: "Ketchup", done: true)
        let greens = Item(title: "Grönsaker", done: true)
        let flingor = Item(title: "Flingor", done: false)
        
        let night = Item(title: "Live by night", done: true)
        let hp = Item(title: "Harry Potter", done: false)
        let gengis = Item(title: "Genghis Khan", done: true)
        let shutter = Item(title: "Shutter Island", done: true)
        let land = Item(title: "Ett land i gryningen", done: true)
        let hob = Item(title: "The Hobbit", done: false)
        let narc = Item(title: "Narconomics", done: true)
        let grit = Item(title: "Grit", done: false)

        let handla = Category(name: "Handla", items: [pasta, bananer, onion, ketchup, greens, flingor])
        let read = Category(name: "Läsa", items: [night, hp, gengis, narc, grit, shutter, land, hob])
        let vardag = Category(name: "Vardag", items: [vakna, frukost, jobba, lunch, train, fritid, sov])

        Service.shared.categories = [handla, read, vardag]
        
    }
    
    //MARK: - Add categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if alertTextField.text == "" { return }
            
            let newCategory = Category(name: alertTextField.text!, items: [])
            Service.shared.categories.append(newCategory)
            self.tableView.reloadData()
        }
        
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Category name.."
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Service.shared.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    
        cell.textLabel?.text = Service.shared.categories[indexPath.row].name
        
        
        return cell
    }
    
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationController.category = Service.shared.categories[indexPath.row]
            destinationController.categoryIndex = indexPath.row
        }
    }
    
    
    
}
