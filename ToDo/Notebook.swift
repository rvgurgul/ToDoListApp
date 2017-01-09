//
//  Notebook.swift
//  ToDo
//
//  Created by Richie Gurgul on 11/15/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import Foundation
import UIKit

enum SortOrder
{
    case ALPHABETICAL
    case CHRONOLOGICAL
    case PRIORITY
}

class Notebook: NSObject, NSCoding
{
    var name: String!
    var color: UIColor!
    var notes: [Note]!
    
    init(_ n: String, _ c: UIColor?)
    {
        name = n
        color = c
        notes = [Note]()
    }
    
    convenience init(_ n: String)
    {
        self.init(n, nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as! String
        color = aDecoder.decodeObject(forKey: "color") as? UIColor
        notes = aDecoder.decodeObject(forKey: "notes") as! [Note]
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(color, forKey: "color")
        aCoder.encode(notes, forKey: "notes")
    }
    
    func sortNotes(in order: SortOrder)
    {
        switch order
        {
        case .ALPHABETICAL:
            notes = notes.sorted(by:
            {   (a, b) -> Bool in
                return a.name < b.name
            })
            break
        case .CHRONOLOGICAL:
            notes = notes.sorted(by:
            {   (a, b) -> Bool in
                if a.date == nil {return false}
                if b.date == nil {return true}
                return a.date!.timeIntervalSince(b.date!) < 0
            })
            break
        case .PRIORITY:
            notes = notes.sorted(by:
            {   (a, b) -> Bool in
                return a.rank.characters.count > b.rank.characters.count
            })
            break
        }
    }
}
