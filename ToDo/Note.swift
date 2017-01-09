//
//  Note.swift
//  ToDo
//
//  Created by Richie Gurgul on 11/15/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import Foundation
import UIKit

class Note: NSObject, NSCoding
{
    var name: String!
    var desc: String!
    var rank: String!
    var date: Date?
    var image: UIImage?
    
    init(_ n: String, _ d: String, _ r: String, _ w: Date?, _ i: UIImage?)
    {
        name = n
        desc = d
        rank = r
        date = w
        image = i
    }
    
    convenience init(_ n: String, _ d: String, _ r: String)
    {
        self.init(n, d, r, nil, nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as! String
        desc = aDecoder.decodeObject(forKey: "desc") as! String
        rank = aDecoder.decodeObject(forKey: "rank") as! String
        date = aDecoder.decodeObject(forKey: "date") as? Date
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(image, forKey: "image")
    }
}
