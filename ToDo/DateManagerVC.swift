//
//  DateManagerVC.swift
//  ToDo
//
//  Created by Richie Gurgul on 12/1/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import Foundation
import UIKit

class DateManagerVC: UIViewController
{
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBackdrop: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    var fromVC: DateManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard fromVC != nil else {return}
        
        cancelButton.applyShadow()
        reminderLabel.applyShadow()
        datePickerBackdrop.applyShadow()
        doneButton.applyShadow()
        
        cancelButton.cutCorners(5)
        reminderLabel.cutCorners(5)
        datePickerBackdrop.cutCorners(10)
        doneButton.cutCorners(25)
    }
    
    @IBAction func cancelButton(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: AnyObject)
    {
        fromVC.returnFromDateManager(datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
}
