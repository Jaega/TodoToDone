//
//  ViewController.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/14/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var todoArray = [TodoItem]()
    var selectedCategory: Category?
    var todoListTableView: UITableView!
    var searchBarView: UISearchBar!
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func loadView() {
        super.loadView()
        
        // init search bar
        searchBarView = UISearchBar(frame: .zero)
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBarView)
        searchBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        
        // init table view
        todoListTableView = UITableView(frame: .zero)
        todoListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(todoListTableView!)
        
        todoListTableView.topAnchor.constraint(equalTo: self.searchBarView.bottomAnchor).isActive = true
        todoListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        todoListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        todoListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
       

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "customTodoCell")
        
        searchBarView.delegate = self

        loadTodoItems()
    }
    
    // MARK: - TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTodoCell", for: indexPath) as! TodoCell
        let item = todoArray[indexPath.row]
        cell.todoItemLabel.text = item.title
        cell.accessoryType = item.checked ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoArray[indexPath.row].checked = !todoArray[indexPath.row].checked
        saveTodoItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add new items
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            // action when user press the add button
            let newItem = TodoItem(context: self.context)
            newItem.title = textField.text!
            newItem.checked = false
            newItem.parentCategory = self.selectedCategory
            self.todoArray.append(newItem)
            self.saveTodoItems()
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    // MARK: - Model manipulation methods
    func saveTodoItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        self.todoListTableView.reloadData()
    }
    
    func loadTodoItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()) {
        let categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedCategory!.title!)
        
        if let paramPredicate = request.predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [paramPredicate, categoryPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            todoArray = try context.fetch(request)
        } catch  {
            print("Error fetching from context: \(error)")
        }
        self.todoListTableView.reloadData()
    }

}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadTodoItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadTodoItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

