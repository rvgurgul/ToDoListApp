//
//  MasterViewController.swift
//  ToDo
//
//  Created by Richie Gurgul on 11/15/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController//, NotebookManager
{
    var detailViewController: DetailViewController? = nil
    var notebooks = [Notebook]()
    {
        didSet
        {
            tableView.reloadData()
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        if let split = self.splitViewController
        {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        load()
        
        returnFromColorPicker("Shopping List", UIColor(red: 243/255, green: 239/255, blue: 125/255, alpha: 1))
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Data Management
    
    func save()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: notebooks)
        UserDefaults.standard.set(data, forKey: "data")
    }
    
    func load()
    {
        if let data = UserDefaults.standard.object(forKey: "data") as? Data
        {
            notebooks = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Notebook]
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toNotebookManager"
        {
            //(segue.destination as! ColorPickerVC).fromVC = self
        }
        else if segue.identifier == "showDetail"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                let book = notebooks[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.notebook = book
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func returnFromColorPicker(_ n: String, _ c: UIColor)
    {
        let book = Notebook(n, c)
        notebooks.append(book)
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notebooks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let book = notebooks[indexPath.row]
        cell.textLabel?.text = book.name
        cell.detailTextLabel?.text = "\(book.notes.count) tasks"
        cell.backgroundColor = book.color
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let temp = notebooks.remove(at: sourceIndexPath.row)
        notebooks.insert(temp, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            notebooks.remove(at: indexPath.row)
        }
    }
}

