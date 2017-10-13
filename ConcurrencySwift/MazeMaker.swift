//
//  MazeMaker.swift
//  ConcurrencySwift
//
//  Created by Andrew Riznyk on 8/24/17.
//  Copyright © 2017 Andrew Riznyk. All rights reserved.
//

import UIKit

class MazeMaker: NSObject {

    var maze = [[Int]]()
    
    func create(){
        for _ in 0..<10 {
           maze.append([1,1,1,1,1,1,1,1,1,1])
        }
     print(maze)
    }
    
    
    
    
}
