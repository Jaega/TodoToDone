//
//  ViewController.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/14/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let realm = try! Realm()
    var todoItems: Results<TodoItem>?
    var selectedCategory: Category?
    var todoListTableView: UITableView!
    var searchBarView: UISearchBar!
    
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
        
        if selectedCategory != nil {
            loadTodoItems()
        }
        
    }
    
    // MARK: - TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTodoCell", for: indexPath) as! TodoCell
        cell.delegate = self
        if let item = todoItems?[indexPath.row] {
            cell.todoItemLabel.text = item.title
            cell.accessoryType = item.checked ? .checkmark : .none
        } else {
            cell.todoItemLabel.text = "No items added"
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.checked = !item.checked
                }
            } catch {
                print("Error updating item: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add new items
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            // action when user press the add button
            if let parentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = TodoItem()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        parentCategory.todoItems.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print("Error saving item: \(error)")
                }
                
                self.todoListTableView.reloadData()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    // MARK: - Model manipulation methods
    
    func loadTodoItems() {
        todoItems = selectedCategory?.todoItems.sorted(byKeyPath: "title", ascending: true)
        self.todoListTableView.reloadData()
    }

}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        todoListTableView.reloadData()
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

extension TodoListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                } catch {
                    print("Error Deleting object: \(error)")
                }
            }
            
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
