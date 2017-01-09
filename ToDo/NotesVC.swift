//
//  NotesVC.swift
//  ToDo
//
//  Created by Richie Gurgul on 11/30/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class NotesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NotebookManager, NoteManager
{
    @IBOutlet weak var table: UITableView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var book: Notebook!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard book != nil else {return}
        
        table.delegate = self
        table.dataSource = self
        
        navigationItem.title = book.name
        table.backgroundColor = book.color
        
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 80
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem)
    {
        table.setEditing(!table.isEditing, animated: true)
    }
    
    @IBAction func actionButton(_ sender: AnyObject)
    {
        let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actions.addAction(UIAlertAction(title: "Sort Options", style: .default, handler:
        {   (action) in
            self.sortActions()
        }))
        actions.addAction(UIAlertAction(title: "Notebook Options", style: .default, handler:
        {   (action) in
            
            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "NotebookManager") as? NotebookManagerVC
            {
                VC.modalPresentationStyle = .overCurrentContext
                VC.modalTransitionStyle = .crossDissolve
                VC.input = self.book.name
                VC.color = self.book.color
                VC.fromVC = self
                
                self.present(VC, animated: true, completion: nil)
            }
        }))
        actions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actions, animated: true, completion: nil)
    }
    
    func sortActions()
    {
        let sortButtons = UIAlertController(title: "Sort:", message: nil, preferredStyle: .actionSheet)
        sortButtons.addAction(UIAlertAction(title: "Alphabetical", style: .default, handler:
        {   (action) in
            self.book.sortNotes(in: .ALPHABETICAL)
            self.table.reloadData()
        }))
        sortButtons.addAction(UIAlertAction(title: "Chronological", style: .default, handler:
        {   (action) in
            self.book.sortNotes(in: .CHRONOLOGICAL)
            self.table.reloadData()
        }))
        sortButtons.addAction(UIAlertAction(title: "Highest Priority", style: .default, handler:
        {   (action) in
            self.book.sortNotes(in: .PRIORITY)
            self.table.reloadData()
        }))
        sortButtons.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
        {   (action) in
            self.actionButton(self)
        }))
        present(sortButtons, animated: true, completion: nil)
    }
    
    func returnFromNotebookManager(_ n: String, _ c: UIColor)
    {
        book.name = n
        book.color = c
        
        navigationItem.title = book.name
        table.backgroundColor = book.color
        
        delegate.save()
    }
    
    func returnFromNoteManager(_ n: String, _ d: String, _ r: String, _ w: Date?, _ i: UIImage?)
    {
        if let indexPath = table.indexPathForSelectedRow
        {
            let note = book.notes[indexPath.row]
            note.name = n
            note.desc = d
            note.rank = r
            note.date = w
            note.image = i
            table.reloadData()
            table.deselectRow(at: indexPath, animated: true)
        }
        else
        {
            let note = Note(n, d, r, w, i)
            book.notes.append(note)
            table.reloadData()
        }
        
        delegate.save()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = table.dequeueReusableCell(withIdentifier: "task", for: indexPath)
        
        let w = CGFloat(0.7 - (0.2 * Double(indexPath.row % 2)))
        cell.backgroundColor = UIColor(white: w, alpha: 0.1)
        cell.textLabel?.backgroundColor = .clear
        cell.detailTextLabel?.backgroundColor = .clear
        
        let note = book.notes[indexPath.row]
        
        if note.rank == ""
        {cell.textLabel?.text = note.name!}
        else
        {cell.textLabel?.text = "[\(note.rank!)] \(note.name!)"}
        
        if note.date == nil
        {cell.detailTextLabel?.text = note.desc}
        else
        {
            let format = DateFormatter()
            format.dateFormat = "E, MMM d, yyyy"
            let date = format.string(from: note.date!)
            cell.detailTextLabel?.text = "(\(date))\n\(note.desc!)"
        }
        
        if let image = note.image
        {cell.imageView?.image = resizeImage(image: image, newWidth: 150)}
        
        return cell
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage
    {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let VC = storyboard?.instantiateViewController(withIdentifier: "NoteManager") as? NoteManagerVC
        {
            VC.modalTransitionStyle = .crossDissolve
            VC.modalPresentationStyle = .overCurrentContext
            VC.fromVC = self
            VC.input = book.notes[indexPath.row]
            
            present(VC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return book.notes.count
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "Completed"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {return true}
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {book.notes.remove(at: indexPath.row)}
        delegate.save()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {return true}
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let temp = book.notes.remove(at: sourceIndexPath.row)
        book.notes.insert(temp, at: destinationIndexPath.row)
        delegate.save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toNoteManager"
        {
            (segue.destination as! NoteManagerVC).fromVC = self
        }
    }
    
    func ohCanada()
    {
        let soary = UIAlertController(title: "Sorry!", message: "This feature is not implemented. The nation of Canada apologizes for the inconvencience.", preferredStyle: .alert)
        soary.addAction(UIAlertAction(title: "It's OK, I forgive you", style: .cancel, handler: nil))
        present(soary, animated: true, completion: nil)
    }
}
