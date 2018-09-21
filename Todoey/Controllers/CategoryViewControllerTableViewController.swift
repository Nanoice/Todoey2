//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Ian Sung on 2018/9/18.
//  Copyright © 2018 Ian Sung. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last

    var categoryArray = [Cateogry]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        print(path)
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]

        cell.textLabel?.text = "🏵" + category.name!
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        context.delete(categoryArray[indexPath.row])
//        categoryArray.remove(at: indexPath.row)
//
//        saveCategory()
//    }
    
    //MARK: - Add New Cateogry
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let ac = UIAlertController(title: "Add category", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            guard textField.text! != "" else {
                let ac2 = UIAlertController(title: "No text inputted", message: nil, preferredStyle: .alert)
                
                ac2.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action) in

                }))
                
                self.present(ac2, animated: true, completion: nil)
                
                return}
            
            let newCategory = Cateogry(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
    }))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        do {
           try context.save()
        } catch {
            print("Error saving categories. \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategory(with request: NSFetchRequest<Cateogry> = Cateogry.fetchRequest()) {
        
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Eror loading categories. \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
}

//MARK: - Searchbar Methods

extension CategoryViewControllerTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let fetchRequest: NSFetchRequest<Cateogry> = Cateogry.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadCategory(with: fetchRequest)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            loadCategory()
            
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        
 
        }
    }
}
