//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by Gill Hardeep on 08/04/20.
//  Copyright © 2020 Gill Hardeep. All rights reserved.
//


import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray: [CategoryClass] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request: NSFetchRequest<CategoryClass> = CategoryClass.fetchRequest()
        do{
        categoryArray = try context.fetch(request)
        }catch{
            print("error making NSFetchRequest \(error)")
        }
        
    }
    
//MARK: - data populate tableview methon
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var text = UITextField()

        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = CategoryClass(context: self.context)
            newCategory.name = text.text!
            self.categoryArray.append(newCategory)
            do{
                try self.context.save()
            }catch{
                print(error)
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            text = alertTextField
            text.placeholder = "add new category"
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)

    }
    
//MARK: - delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}
