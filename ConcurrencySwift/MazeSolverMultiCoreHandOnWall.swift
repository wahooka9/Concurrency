//
//  MazeSolverMultiCoreHandOnWall.swift
//  ConcurrencySwift
//
//  Created by Andrew Riznyk on 9/1/17.
//  Copyright © 2017 Andrew Riznyk. All rights reserved.
//

import UIKit

class MazeSolverMultiCoreHandOnWall: NSObject {
    var maze : [[Int8]]!
    var mazestack : [posistion]!
    var counter : Int = 0
    
    var checkedPosistions : Set<posistion>
    
    var delegate : mazeSolverDelegate?
    
    override init() {
        self.checkedPosistions = Set()
        if let newStack = mazestack {
            self.mazestack = newStack
        } else {
            self.mazestack = [posistion]()
            self.mazestack.append(posistion(x: 1, y: 1))
        }
    }
    
    func start(){
        self.checkedPosistions = Set()
        self.mazestack = [posistion]()
        self.mazestack.append(posistion(x: 1, y: 1))
        self.next(stak:self.mazestack)
    }
    
    func next(stak:[posistion]){
        autoreleasepool {
        let pos = stak.last!
            
            objc_sync_enter(self)
            if self.checkedPosistions.contains(pos) {
                objc_sync_exit(self)
                return
            }
            self.checkedPosistions.insert(pos)
            objc_sync_exit(self)
        if pos != posistion(x: self.maze.count-2,y: self.maze.count-2) {
            if canGoRight(last: pos, stack: stak) {
                DispatchQueue.global().async {
                    var stk : [posistion] = stak
                    stk.append(posistion(x:pos.x+2 , y: pos.y))
                    self.next(stak: stk)
                }
            }
            if canGoUp(last: pos, stack: stak){
                DispatchQueue.global().async {
                    var stk : [posistion] = stak
                    stk.append(posistion(x:pos.x , y: pos.y-2))
                    self.next(stak: stk)
                }
            }
            if canGoLeft(last: pos, stack: stak){
                DispatchQueue.global().async {
                    var stk : [posistion] = stak
                    stk.append(posistion(x:pos.x-2 , y: pos.y))
                    self.next(stak: stk)
                }
            }
            if canGoDown(last: pos, stack: stak){
                DispatchQueue.global().async {
                    var stk : [posistion] = stak
                    stk.append(posistion(x:pos.x , y: pos.y+2))
                    self.next(stak: stk)
                }
            }
        } else {
            self.mazestack = stak
            if let del = delegate {
                del.showMazeComplete()
            }
        }
            
        }
        
    }
    
    
    func canGoRight(last : posistion, stack:[posistion]) -> Bool {
        if last.x < maze.count-1 {
            if stack.contains(posistion(x: last.x+2,y: last.y)){
                return false
            }
            return maze[last.x+1][last.y] == 0
        }
        return false
    }
    
    func canGoLeft(last : posistion, stack:[posistion]) -> Bool {
        if last.x > 1 {
            if stack.contains(posistion(x: last.x-2,y: last.y)){
                return false
            }
            return maze[last.x-1][last.y] == 0
        }
        return false
    }
    
    func canGoUp(last : posistion, stack:[posistion]) -> Bool {
        if last.y > 1 {
            if stack.contains(posistion(x: last.x,y: last.y-2)){
                return false
            }
            return maze[last.x][last.y-1] == 0
        }
        return false
    }
    
    func canGoDown(last : posistion, stack:[posistion]) -> Bool {
        if last.y < maze[last.x].count-1 {
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
        for pos in mazestack {
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

    

}
