//
//  ViewController.swift
//  ConcurrencySwift
//
//  Created by Andrew Riznyk on 8/23/17.
//  Copyright © 2017 Andrew Riznyk. All rights reserved.
//

import UIKit

protocol mazeDelegate : class {
    func showMaze(layer:CAShapeLayer, maze:[[Int8]])
}

protocol mazeSolverDelegate : class {
    func showMazeComplete()
}

struct posistion {
    let x : Int
    let y : Int
    
    init(x:Int,y:Int) {
        self.x = x
        self.y = y
    }
}

class ViewController: UIViewController {
    
    var size  = 20
    let mazeMulti = MazeDispatchGroup()
    let mazeSolo = MazeSingleCore()
    
    let solverSolo = MazeSolverSingleCoreHandOnWall()
    let solverMulti = MazeSolverMultiCoreHandOnWall()
    
    var maze = [[Int8]]()

    var mazeLayer : CAShapeLayer!
    var solveLayer : CAShapeLayer!
    
    @IBOutlet weak var multicoreLabel: UILabel!
    @IBOutlet weak var multicoreSwitchOutlet: UISwitch!
    @IBOutlet weak var stepperValueLabelOutlet: UILabel!
    @IBOutlet weak var stepperButtonOutlet: UIStepper!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mazeMulti.delegate = self
        mazeSolo.delegate = self
        self.stepperValueLabelOutlet.text = "\((Int)(self.stepperButtonOutlet.value))"
        size  = Int(self.stepperButtonOutlet.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        scrollView.isScrollEnabled = true;
        self.updateScrollSize()
    }
    
    func updateScrollSize() {
        scrollView.contentSize = CGSize(width: Double(size)*11.2, height: Double(size)*11.2)
        scrollView.setNeedsDisplay()
    }
    
    @IBAction func stepperButtonAction(_ sender: Any) {
        self.stepperValueLabelOutlet.text = "\((Int)(self.stepperButtonOutlet.value))"
        size  = Int(self.stepperButtonOutlet.value)
    }

    
    @IBAction func buildAction(_ sender: Any) {
        if let layer = self.mazeLayer {
            layer.removeFromSuperlayer()
        }
        if let layer = self.solveLayer {
            layer.removeFromSuperlayer()
        }
        if multicoreSwitchOutlet.isOn {
            mazeMulti.create(size: size)
        } else {
            mazeSolo.create(size: size)
        }
    }

    @IBAction func solveAction(_ sender: Any) {
        if let layer = self.solveLayer {
            layer.removeFromSuperlayer()
        }
        if multicoreSwitchOutlet.isOn {
            solverMulti.delegate = self
            solverMulti.maze = self.maze
            solverMulti.start()
        } else {
            solverSolo.maze = self.maze
            solverSolo.handOnWall()
            solveLayer = solverSolo.createPath()
            self.mapView.layer.addSublayer(solveLayer)
        }
    }
}

extension ViewController : mazeDelegate {
    func showMaze(layer:CAShapeLayer, maze:[[Int8]]) {
        DispatchQueue.main.async{
            self.updateScrollSize()
            self.mazeLayer = layer
            self.mapView.layer.addSublayer(self.mazeLayer)
        }
        self.maze = maze
    }
}

extension ViewController : mazeSolverDelegate {
    func showMazeComplete(){
        solveLayer = solverMulti.createPath()
        DispatchQueue.main.async{
            self.mapView.layer.addSublayer(self.solveLayer)
        }
    }
}

extension posistion : Equatable {
    static func ==(lhs: posistion, rhs: posistion) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension posistion : Hashable {
    var hashValue: Int {
        let val = "x\(x)y\(y)"
        return val.hash
    }
}



