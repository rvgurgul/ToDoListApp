//
//  NotebooksVC.swift
//  ToDo
//
//  Created by Richie Gurgul on 11/30/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class NotebooksVC: UIViewController, NotebookManager, UITableViewDataSource, UITableViewDelegate
{
    //Outlet for the main table view
    @IBOutlet weak var table: UITableView!
    
    //File path of data storage
    var filePath: String
    {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        return url.appendingPathComponent("savedData").path
    }
    
    //User's notebooks
    var notebooks = [Notebook](){
        didSet{
            //Whenever the notebooks change, update the view to reflect the changes
            table.reloadData()
            //And save the changes
            save()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        table.separatorColor = UIColor(white: 0.2, alpha: 1)
        
        load()
        
        //Allows other views to access this class's save ability
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.instance = self
    }
    
    //Reflect changes made whenever the user comes back to this main view
    override func viewWillAppear(_ animated: Bool){
        table.reloadData()
    }
    
    //Save data!
    func save(){
        NSKeyedArchiver.archiveRootObject(notebooks, toFile: filePath)
    }
    
    //Load data!
    func load(){
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Notebook]{
            notebooks = array
        }
        //If there is noting to load, then add a default notebook.
        else{
            returnFromNotebookManager("Shopping List", UIColor(red: 243/255, green: 239/255, blue: 125/255, alpha: 1))
        }
    }
    
    //Toggle editing of the table
    @IBAction func editButton(_ sender: AnyObject){
        table.setEditing(!table.isEditing, animated: true)
    }
    
    //Add a new notebook based off of the data returned from the Notebook Manager VC
    func returnFromNotebookManager(_ n: String, _ c: UIColor){
        let book = Notebook(n, c)
        notebooks.append(book)
    }
    
    //1 notebook per row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return notebooks.count
    }
    
    //Display the notebook's name, color, and number of tasks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "book", for: indexPath)
        
        let book = notebooks[indexPath.row]
        cell.textLabel?.text = book.name
        cell.detailTextLabel?.text = "\(book.notes.count) tasks"
        cell.backgroundColor = book.color
        
        return cell
    }
    
    //Editing capabilities
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {return true}
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {notebooks.remove(at: indexPath.row)}
    }
    
    //Reordering capabilities
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {return true}
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        let temp = notebooks.remove(at: sourceIndexPath.row)
        notebooks.insert(temp, at: destinationIndexPath.row)
    }
    
    //Segue to the other VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toNotebookManager"{
            (segue.destination as! NotebookManagerVC).fromVC = self
        }
        else if segue.identifier == "toNotesVC"{
            if let indexPath = table.indexPathForSelectedRow{
                (segue.destination as! NotesVC).book = notebooks[indexPath.row]
            }
        }
    }
}
