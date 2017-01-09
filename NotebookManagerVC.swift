//
//  ColorPickerVC.swift
//  ToDo
//
//  Created by Richie Gurgul on 11/15/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class NotebookManagerVC: UIViewController, UITextFieldDelegate
{
    //Tons of outlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rgbField: UITextField!
    @IBOutlet weak var rSlider: UISlider!
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var bSlider: UISlider!
    
    //RGB Values
    var r: Float = 1
    var g: Float = 1
    var b: Float = 1
    
    //Minimum value to not let the user go below.
    let min: Float = 1/5
    
    var input = ""
    var color = UIColor.white
    var fromVC: NotebookManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard fromVC != nil else {return}
        
        nameField.delegate = self
        rgbField.delegate = self
        
        //NotebookManagers can input a notebook's name to be automatically put into the field
        nameField.text = input
        
        //Same with the color
        let temp = CIColor(color: color)
        r = Float(temp.red)
        g = Float(temp.green)
        b = Float(temp.blue)
        rSlider.value = r
        gSlider.value = g
        bSlider.value = b
        updateColor()
        
        //Applies a shadow effect to all the views
        nameField.applyShadow()
        rgbField.applyShadow()
        rSlider.applyShadow()
        gSlider.applyShadow()
        bSlider.applyShadow()
        cancelButton.applyShadow()
        doneButton.applyShadow()
        
        cancelButton.cutCorners(5)
        doneButton.cutCorners(5)
    }
    
    @IBAction func rDidChange(_ sender: AnyObject)
    {
        if rSlider.value > min
        {
            r = rSlider.value
            updateColor()
        }
    }
    
    @IBAction func gDidChange(_ sender: AnyObject)
    {
        if gSlider.value > min
        {
            g = gSlider.value
            updateColor()
        }
    }
    
    @IBAction func bDidChange(_ sender: AnyObject)
    {
        if bSlider.value > min
        {
            b = bSlider.value
            updateColor()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == rgbField
        {
            let strings = rgbField.text!.components(separatedBy: ",")
            if strings.count == 3
            {
                if let red = Int(strings[0])
                {
                    r = Float(red) / 255
                    if r < min {r = min}
                    else if r > 1 {r = 1}
                    rSlider.value = r
                }
                else
                {print("Invalid R")}
                
                if let green = Int(strings[1])
                {
                    g = Float(green) / 255
                    if g < min {g = min}
                    else if g > 1 {g = 1}
                    gSlider.value = g
                }
                else
                {print("Invalid G")}
                
                if let blue = Int(strings[2])
                {
                    b = Float(blue) / 255
                    if b < min {b = min}
                    else if b > 1 {b = 1}
                    bSlider.value = b
                }
                else
                {print("Invalid B")}
                
                updateColor()
            }
            else
            {
                let invalidAlert = UIAlertController(title: "Invalid RGB value entered.", message: "Format your color as \"RRR, GGG, BBB\"", preferredStyle: .alert)
                invalidAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                present(invalidAlert, animated: true, completion: nil)
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    func updateColor()
    {
        color = UIColor(colorLiteralRed: r, green: g, blue: b, alpha: 1)
        
        rgbField.text! = "\(Int(r * 255)), \(Int(g * 255)), \(Int(b * 255))"
        
        nameField.backgroundColor = color
        rgbField.backgroundColor = color
        rSlider.thumbTintColor = color
        gSlider.thumbTintColor = color
        bSlider.thumbTintColor = color
        cancelButton.backgroundColor = color
        doneButton.backgroundColor = color
    }
    
    @IBAction func cancelButton(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
        if let VC = fromVC as NotebookManager?
        {
            var bookName = nameField.text!
            if bookName == "" {bookName = "New Notebook"}
            
            VC.returnFromNotebookManager(bookName, color)
        }
    }
}
