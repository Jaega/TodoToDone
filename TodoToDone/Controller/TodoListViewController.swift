//
//  ViewController.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/14/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var todoArray = [TodoItem]()
    var todoListTableView: UITableView!
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func loadView() {
        super.loadView()
        
        todoListTableView = UITableView(frame: .zero)
        todoListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(todoListTableView!)
        
        todoListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        todoListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        todoListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        todoListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "customTodoCell")

        loadTodoItem()
        
//        if let itemArray = defaults.array(forKey: "TodoListArray") as? [TodoItem] {
//            todoArray = itemArray
//            todoListTableView.reloadData()
//        }
    }
    
    // MARK: - TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTodoCell", for: indexPath) as! TodoCell
        let item = todoArray[indexPath.row]
        cell.TodoItemLabel.text = item.title
        cell.accessoryType = item.checked ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoArray[indexPath.row].checked = !todoArray[indexPath.row].checked
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add new items
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        var newItemName = ""
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new item", style: .default) { action in
            // action when user press the add button
            newItemName = alert.textFields![0].text!
            let newItem = TodoItem(name: newItemName, done: false)
            self.todoArray.append(newItem)
            
            //self.defaults.set(self.todoArray, forKey: "TodoListArray")
            self.saveTodoItem()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model manipulation methods
    func saveTodoItem() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.todoArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print(error)
        }
        self.todoListTableView.reloadData()
    }
    
    func loadTodoItem() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                todoArray = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print(error)
            }
        }
    }

}

