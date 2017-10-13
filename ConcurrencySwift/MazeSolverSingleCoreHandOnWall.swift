//
//  MazeSolverSingleCore.swift
//  ConcurrencySwift
//
//  Created by Andrew Riznyk on 8/29/17.
//  Copyright © 2017 Andrew Riznyk. All rights reserved.
//

import UIKit



class MazeSolverSingleCoreHandOnWall: NSObject {
    var maze : [[Int8]]!
    var stack = [posistion]()
    
    func handOnWall() {
        stack = [posistion]()
        stack.append(posistion(x: 1,y: 1))
        while stack.last != posistion(x: maze.count-2,y: maze.count-2) {
            let last : posistion = stack.last!
            right(last: last)
        }
    }
    
    func backUp(){
        let previous = stack.removeLast()
        let last = stack.last!
        if previous.x > last.x {
            maze[previous.x-1][previous.y] = 1;
            down(last: last)
        } else if previous.x < last.x {
            maze[previous.x+1][previous.y] = 1;
            up(last: last)
        } else if previous.y > last.y {
            maze[previous.x][previous.y-1] = 1;
            left(last: last)
        } else {
            backUp()
        }
        
    }
    
    func right(last: posistion){
        if (canGoRight(last: last)){
            stack.append(posistion(x: last.x+2,y: last.y))
        } else if (canGoDown(last: last)){
            stack.append(posistion(x: last.x,y: last.y+2))
        } else if (canGoLeft(last: last)) {
            stack.append(posistion(x: last.x-2,y: last.y))
        } else if (canGoUp(last: last)){
            stack.append(posistion(x: last.x,y: last.y-2))
        } else {
            backUp()
        }
    }
    
    func down(last: posistion){
        if (canGoDown(last: last)){
            stack.append(posistion(x: last.x,y: last.y+2))
        } else if (canGoLeft(last: last)) {
            stack.append(posistion(x: last.x-2,y: last.y))
        } else if (canGoUp(last: last)){
            stack.append(posistion(x: last.x,y: last.y-2))
        } else {
            backUp()
        }
    }
    
    func left(last: posistion){
        if (canGoLeft(last: last)) {
            stack.append(posistion(x: last.x-2,y: last.y))
        } else if (canGoUp(last: last)){
            stack.append(posistion(x: last.x,y: last.y-2))
        } else {
            backUp()
        }
    }
    
    func up(last: posistion){
        if (canGoUp(last: last)){
            stack.append(posistion(x: last.x,y: last.y-2))
        } else {
            backUp()
        }
    }
    
    func canGoRight(last : posistion) -> Bool {
        if last.x < maze.count-2 {
            if stack.contains(posistion(x: last.x+2,y: last.y)){
                return false
            }
            return maze[last.x+1][last.y] == 0
        }
        return false
    }
    
    func canGoLeft(last : posistion) -> Bool {
        if last.x > 1 {
            if stack.contains(posistion(x: last.x-2,y: last.y)){
                return false
            }
            return maze[last.x-1][last.y] == 0
        }
        return false
    }
    
    func canGoUp(last : posistion) -> Bool {
        if last.y > 1 {
            if stack.contains(posistion(x: last.x,y: last.y-2)){
                return false
            }
            return maze[last.x][last.y-1] == 0
        }
        return false
    }
    
    func canGoDown(last : posistion) -> Bool {
        if last.y < maze[last.x].count-2 {
            if stack.contains(posistion(x: last.x,y: last.y+2)){
                return false
            }
            return maze[last.x][last.y+1] == 0
        }
        return false
    }
    
    func createPath()->CAShapeLayer{
        let space = 5
        let myBezier = UIBezierPath()
        let layer = CAShapeLayer()
        
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.borderColor = UIColor.white.cgColor
        var last : posistion?
        for pos in stack {
            if let previous = last {
                let yStartPoint = previous.x*space
                let xStartPoint = previous.y*space
                myBezier.move(to: CGPoint(x: xStartPoint, y: yStartPoint))
                let yEndPoint = (pos.x)*space
                let xEndPoint = (pos.y)*space
                myBezier.addLine(to: CGPoint(x: xEndPoint, y: yEndPoint))
                layer.path = myBezier.cgPath
            }
            last = pos;
        }
        return layer;
    }
    
    func printMaze(){
        for x in maze {
            print(x)
        }
    }
}

