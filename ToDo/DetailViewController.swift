//
//  DetailViewController.swift
//  ToDo
//
//  Created by Richie Gurgul on 11/15/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate//, NotebookManager
{
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var bar: UIToolbar!
    
    var notebook: Notebook!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard notebook != nil else {return}
       
        navigationItem.title = notebook.name
        table.backgroundColor = notebook.color
        
        table.delegate = self
        table.dataSource = self
        
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 50
        
        bar.items?.append(editButtonItem)
        bar.items?.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        bar.items?.append(UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: #selector(DetailViewController.actionButton)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "createTask"
        {
            //(segue.destination as! TaskAdderVC).fromVC = self
        }
    }
    
    func addTask(_ note: Note)
    {
        notebook.notes.append(note)
        table.reloadData()
    }

    func actionButton()
    {
        let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actions.addAction(UIAlertAction(title: "Sort Options", style: .default, handler:
        {   (action) in
            
        }))
        actions.addAction(UIAlertAction(title: "Notebook Options", style: .default, handler:
        {   (action) in
            
            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "NotebookManager") as? NotebookManagerVC
            {
                VC.modalPresentationStyle = .overCurrentContext
                VC.modalTransitionStyle = .crossDissolve
                VC.input = self.notebook.name
                VC.color = self.notebook.color
                //VC.fromVC = self
                
                self.present(VC, animated: true, completion: nil)
            }
        }))
        actions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actions, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = table.dequeueReusableCell(withIdentifier: "task", for: indexPath)
        
        let w = CGFloat(0.7 - (0.2 * Double(indexPath.row % 2)))
        cell.backgroundColor = UIColor(white: w, alpha: 0.1)
        
        let note = notebook.notes[indexPath.row]
        cell.textLabel?.text = note.name
        cell.detailTextLabel?.text = note.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0//notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "Completed"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {return true}
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {return true}
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            notebook.notes.remove(at: indexPath.row)
            table.reloadData()
        }
    }
    
    func returnFromColorPicker(_ n: String, _ c: UIColor)
    {
        notebook.name = n
        notebook.color = c
        
        navigationItem.title = notebook.name
        table.backgroundColor = notebook.color
    }
    
    var independence: Any! //The declaration of independence.
}
