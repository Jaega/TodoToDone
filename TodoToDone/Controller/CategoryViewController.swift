//
//  CategoryViewController.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/18/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let realm = try! Realm()
    var categories: Results<Category>?
    var categoryTableView: UITableView!

    
    override func loadView() {
        super.loadView()
        // init table view
        categoryTableView = UITableView(frame: .zero)
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(categoryTableView!)
        
        categoryTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        categoryTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        categoryTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        categoryTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "customCategoryCell")
        loadCategories()

    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCategoryCell", for: indexPath) as! CategoryCell
        cell.categoryLabel.text = categories?[indexPath.row].title ?? "No category available"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "todoListVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Table View Data Source Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todoListVC" {
            let destinationVC = segue.destination as! TodoListViewController
            let index = categoryTableView.indexPathForSelectedRow?.row
            destinationVC.selectedCategory = categories?[index!]
        }
    }
    

    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category()
            newCategory.title = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Model manipulation methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        self.categoryTableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        self.categoryTableView.reloadData()
    }
}
