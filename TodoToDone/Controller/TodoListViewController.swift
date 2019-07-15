//
//  ViewController.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/14/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var todoArray = ["Buy eggs", "Chat", "Take courses"]
    var todoListTableView: UITableView!
    
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
    }
    
    // MARK: - TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTodoCell", for: indexPath) as! TodoCell
        cell.TodoItemLabel.text = todoArray[indexPath.row]
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add new items
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        var newItemName = ""
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new item", style: .default) { action in
            // action when user press the add button
            newItemName = alert.textFields![0].text!
            self.todoArray.append(newItemName)
            self.todoListTableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

