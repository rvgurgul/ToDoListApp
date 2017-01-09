//
//  TaskAdderVC.swift
//  ToDo
//
//  Created by Richie Gurgul on 11/18/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class NoteManagerVC: UIViewController, DateManager, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bottomBar: UIToolbar!
    var imageBarButton: UIBarButtonItem!
    var dateBarButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    var fromVC: NoteManager!
    var input: Note?
    
    var date: Date? = nil
    var image: UIImage? = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard fromVC != nil else {return}
        
        //Space Image Space Date  Space
        //  0     1     2     3     4
        imageBarButton = bottomBar.items?[1]
        dateBarButton = bottomBar.items?[3]
        
        imagePicker.delegate = self
        
        nameField.applyShadow()
        segmentBar.applyShadow()
        descField.applyShadow()
        cancelButton.applyShadow()
        addButton.applyShadow()
        bottomBar.applyShadow()
        
        segmentBar.cutCorners(5)
        descField.cutCorners(5)
        cancelButton.cutCorners(5)
        addButton.cutCorners(5)
        
        if let note = input
        {
            nameField.text = note.name
            descField.text = note.desc
            segmentBar.selectedSegmentIndex = note.rank.characters.count
            image = note.image
            date = note.date
        }
    }
    
    func returnFromDateManager(_ d: Date)
    {
        date = d
        dateBarButton.tintColor = bottomBar.tintColor
    }
    
    @IBAction func cancelButton(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: AnyObject)
    {
        let name = nameField.text!
        
        if name == ""
        {
            let nameAlert = UIAlertController(title: "Empty Name Field", message: "You must enter a name.", preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(nameAlert, animated: true, completion: nil)
            return
        }
        
        let desc = descField.text!
        let rank = segmentBar.titleForSegment(at: segmentBar.selectedSegmentIndex)!
        
        fromVC.returnFromNoteManager(name, desc, rank, date, image)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButton(_ sender: AnyObject)
    {
        let actions = UIAlertController(title: "Set an image?", message: nil, preferredStyle: .actionSheet)
        actions.addAction(UIAlertAction(title: "Choose from library.", style: .default, handler:
        {   (action) in
            self.showPhotoPicker(type: .photoLibrary)
        }))
        actions.addAction(UIAlertAction(title: "Take a photo.", style: .default, handler:
        {   (action) in
            self.showPhotoPicker(type: .camera)
        }))
        actions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actions, animated: true, completion: nil)
    }
    
    func showPhotoPicker(type: UIImagePickerControllerSourceType)
    {
        if UIImagePickerController.isSourceTypeAvailable(type)
        {
            imagePicker.sourceType = type
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .overCurrentContext
            imagePicker.modalTransitionStyle = .crossDissolve
            present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let unavailable = UIAlertController(title: "\(nameFor(sourceType: type)) is unavailable.", message: nil, preferredStyle: .alert)
            unavailable.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(unavailable, animated: true, completion: nil)
        }
    }
    
    private func nameFor(sourceType: UIImagePickerControllerSourceType) -> String
    {
        switch sourceType
        {
        case .camera:
            return "Camera"
        case .photoLibrary:
            return "Photo Library"
        case .savedPhotosAlbum:
            return "Saved Photos Album"
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let temp = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            image = temp
            imageBarButton.tintColor = bottomBar.tintColor
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toDateManager"
        {
            (segue.destination as! DateManagerVC).fromVC = self
        }
    }
}
