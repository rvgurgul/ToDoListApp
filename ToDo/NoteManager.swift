//
//  NoteManager.swift
//  ToDo
//
//  Created by Richie Gurgul on 12/1/16.
//  Copyright © 2016 Richie Gurgul. All rights reserved.
//

import Foundation
import UIKit

protocol NoteManager
{
    func returnFromNoteManager(_ n: String, _ d: String, _ r: String, _ w: Date?, _ i: UIImage?)
}
