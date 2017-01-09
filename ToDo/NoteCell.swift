//
//  NoteCell.swift
//  ToDo
//
//  Created by Richie Gurgul on 12/2/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell
{
    var note: Note!
    {
        didSet
        {
            let nameLabelFrame = CGRect(x: 0, y: 0, width: frame.width, height: 32)
            let nameLabel = UILabel(frame: nameLabelFrame)
            
            nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
            if note.rank != ""  {nameLabel.text = "[\(note.rank!)] \(note.name!)"}
            else                {nameLabel.text = "\(note.name!)"}
            nameLabel.backgroundColor = .red
            addSubview(nameLabel)
            
            ADD_DESCRIPTION_AND_IMAGE_VIEWS: do
            {
                var descLabelFrame: CGRect!
                var imageDisplayFrame: CGRect!
                
                if note.desc == "" && note.image == nil
                {
                    print("no description, no image")
                    break ADD_DESCRIPTION_AND_IMAGE_VIEWS
                }
                else if note.desc == "" && note.image != nil
                {
                    print("no description, yes image")
                    //HEIGHT CALCULATIONS
                    
                    // image.w   image.h
                    // ------- = -------
                    // frame.w   frame.h
                    
                    //frame.h * image.w = image.h * frame.w
                    
                    //frame.h = image.h * frame.w / image.w
                    
                    let calculatedHeight = (note.image!.size.height * frame.width) / note.image!.size.width
                    imageDisplayFrame = CGRect(x: 0, y: 32, width: frame.width, height: calculatedHeight)
                }
                else if note.desc != "" && note.image == nil
                {
                    print("yes description, no image")
                    descLabelFrame = CGRect(x: 0, y: 32, width: frame.width, height: 128)
                }
                else
                {
                    descLabelFrame = CGRect(x: 0, y: 32, width: frame.width / 2, height: 128)
                    let calculatedHeight = (note.image!.size.height * (frame.width / 2)) / note.image!.size.width
                    imageDisplayFrame = CGRect(x: frame.width / 2, y: 32, width: frame.width / 2, height: calculatedHeight)
                    print("yes description, yes image")
                }
                
                if descLabelFrame != nil
                {
                    let descLabel = UILabel(frame: descLabelFrame)
                    descLabel.font = UIFont.systemFont(ofSize: 18)
                    descLabel.numberOfLines = 0 //auto expansion
                    descLabel.lineBreakMode = .byWordWrapping
                    descLabel.text = note.desc!
                    descLabel.backgroundColor = .orange
                    descLabel.sizeToFit()
                    addSubview(descLabel)
                }
                
                if imageDisplayFrame != nil
                {
                    let imageDisplay = UIImageView(frame: imageDisplayFrame)
                    imageDisplay.image = note.image!
                    imageDisplay.contentMode = .scaleToFill
                    imageDisplay.backgroundColor = .yellow
                    imageDisplay.sizeToFit()
                    addSubview(imageDisplay)
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
