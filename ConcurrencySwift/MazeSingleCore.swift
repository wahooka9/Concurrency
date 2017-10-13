//
//  Maze.swift
//  ConcurrencySwift
//
//  Created by Andrew Riznyk on 8/28/17.
//  Copyright © 2017 Andrew Riznyk. All rights reserved.
//

import UIKit

class MazeSingleCore: NSObject {
    var maze = [[Int8]]()
    var size : Int!
    
    var delegate :mazeDelegate?
    
    func create(size : Int){
        self.size = size
        maze = [[Int8]]()
        var array = [Int8]()
        let mazeSize = size * 2 + 1
        for index in 0..<mazeSize {
            if index == 0 || index == (mazeSize-1) {
                array.append(1)
            } else {
                array.append(0)
            }
        }
        for _ in 0..<mazeSize {
            maze.append(array)
        }
        for index in 0..<mazeSize {
            maze[0][index] = 1
            maze[mazeSize-1][index] = 1
        }
        maze[1][0] = 0
        maze[mazeSize-2][mazeSize-1] = 0
        self.putUpWallVertical(xpos: 0, ypos: 0, x: mazeSize, y: mazeSize)
        self.createPath()
    }
        
    //2K  walls -  Always even
    func getRandomWall(max:Int) -> Int{
        if max <= 3 { return 2 }
        let random = Int(arc4random()) % ((max-2) / 2)
        let slot = (random + 1) * 2
        return slot
    }
        
    //2K + 1  holes -  Always odd
    func getRandomHole(max:Int) -> Int{
        let random = Int(arc4random()) % ((max-1) / 2)
        let slot = (random * 2) + 1
        return slot
    }
        
    func putUpWallVertical(xpos: Int, ypos: Int, x: Int, y: Int){
        if x <= 3 || y <= 3 {
            return
        }
        let randomWallPos = getRandomWall(max: x)
        for posistion in ypos..<(y+ypos) {
            maze[posistion][randomWallPos + xpos] = 1;
        }
        for _ in 0..<((y/20)+1){
            maze[getRandomHole(max:y) + ypos][randomWallPos + xpos] = 0;
        }
        self.putUpWallHorizontal(xpos: xpos, ypos: ypos, x: randomWallPos, y: y)
        self.putUpWallHorizontal(xpos: randomWallPos + xpos , ypos: ypos, x: x - randomWallPos, y: y)
    }
        
    func putUpWallHorizontal(xpos: Int, ypos: Int, x: Int, y: Int){
        if y <= 3 || x<=3  {
            return
        }
        let randomWallPos = getRandomWall(max: y)
        for posistion in xpos..<(xpos+x) {
            maze[randomWallPos + ypos][posistion] = 1;
        }
        for _ in 0..<((x/20)+1) {
            maze[randomWallPos + ypos][getRandomHole(max:x) + xpos] = 0;
        }
        self.putUpWallVertical(xpos: xpos, ypos: ypos, x: x, y: randomWallPos)
        self.putUpWallVertical(xpos: xpos, ypos: randomWallPos + ypos, x: x, y: y - randomWallPos)
    }
    
    
    func createPath(){
        let space = 5
        let myBezier = UIBezierPath()
        let layer = CAShapeLayer()
        
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.borderColor = UIColor.white.cgColor
        
        for ypos in 0..<maze.count {
            for xpos in 0..<maze[ypos].count {
                let xStartPoint = xpos*space
                let yStartPoint = ypos*space
                if(getRight(xpos:xpos, ypos:ypos)){
                    myBezier.move(to: CGPoint(x: xStartPoint, y: yStartPoint))
                    let xEndPoint = (xpos+1)*space
                    myBezier.addLine(to: CGPoint(x: xEndPoint, y: yStartPoint))
                    layer.path = myBezier.cgPath
                }
                
                if (getDown(xpos:xpos, ypos:ypos)){
                    myBezier.move(to: CGPoint(x: xStartPoint, y: yStartPoint))
                    let yEndPoint = (ypos+1)*space
                    myBezier.addLine(to: CGPoint(x: xStartPoint, y: yEndPoint))
                    layer.path = myBezier.cgPath
                }
                
            }
        }
        
        if let mazeDelegate = self.delegate {
            mazeDelegate.showMaze(layer: layer, maze:self.maze)
        }
    }
    
    func getRight(xpos:Int, ypos:Int) -> Bool{
        if xpos + 1 >= maze.count {
            return false
        } else if maze[ypos][xpos + 1] == 0 {
            return false
        } else if maze[ypos][xpos] == 1 && maze[ypos][xpos + 1] == 1 {
            return true
        }
        return false
    }
    
    func getDown(xpos:Int, ypos:Int) -> Bool{
        if (ypos + 1) >= maze.count {
            return false
        } else if maze[ypos+1][xpos] == 0 {
            return false
        } else if maze[ypos][xpos] == 1 && maze[ypos+1][xpos] == 1 {
            return true
        }
        return false
    }

    func printMaze(){
        for x in maze {
            print(x)
        }
    }
}
