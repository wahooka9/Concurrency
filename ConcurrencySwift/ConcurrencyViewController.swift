//
//  ConcurrencyViewController.swift
//  ConcurrencySwift
//
//  Created by Andrew Riznyk on 9/28/17.
//  Copyright © 2017 Andrew Riznyk. All rights reserved.
//

import UIKit

let lock = NSLock()
let cond = NSCondition()
var arry = [Int]()




class WriterThread : Thread {
    
    override func main(){
        for x in 0..<5 {
            cond.lock()
            arry.append(x)
            cond.signal() // Notify and wake up the waiting thread/s
            cond.unlock()
        }
    }
}

class ReaderThread : Thread {
    
    override func main(){
        while !arry.isEmpty {
            cond.lock()
            while(arry.isEmpty){
                cond.wait()
            }
            print(arry.popLast()!)
            cond.signal()
            cond.unlock()
        }
    }
}


class BasicThread : Thread {
    override func main(){
        lock.lock()
        print("Thread started, sleep for 2 seconds...")
        var arry:Array = [Int]()
        for x in 0..<1000 {
            arry.append(x)
        }
        Thread.sleep(until: Date().addingTimeInterval(2))
        print("Done sleeping, exiting thread")
        lock.unlock()
    }
}

class ConcurrencyViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func runThread(_ sender: Any) {
//        let basicThread:BasicThread = BasicThread()
//
//        let basicThread2 = Thread {
//            lock.lock()
//            print("Thread started, sleep for 2 seconds...")
//            var arry:Array = [Int]()
//            for x in 0..<1000 {
//                arry.append(x)
//            }
//            Thread.sleep(until: Date().addingTimeInterval(2))
//            print("Done sleeping, exiting thread")
//            lock.unlock()
//        }
//        basicThread.start()
//        basicThread2.start()
    
//        let writet = WriterThread()
//        let readt = ReaderThread()
//        readt.start()
//        writet.start()
        
        
//        var counter : Int64 = 0
//        let group = DispatchGroup()
//
//        let date = Date()
//        DispatchQueue.global().async {
//            group.enter()
//            for _ in 0..<5000 {
//                OSAtomicIncrement64(&counter)
//            }
//            group.leave()
//        }
        
//        DispatchQueue.global().async {
//            group.enter()
//            for _ in 0..<5000 {
//                objc_sync_enter(self)
//                counter += 1
//                objc_sync_exit(self)
//            }
//            group.leave()
//        }
        
//        group.notify(queue: .global()) {
//            let dateNow = Date()
//            print(dateNow.timeIntervalSince(date))
//            print(counter)
//        }

//        let sem = DispatchSemaphore(value:2)
        
        // The semaphore will be held by groups of two pool threads

//            DispatchQueue.concurrentPerform(iterations: 10) { (id:Int) in
//                sem.wait(timeout: DispatchTime.distantFuture)
//                sleep(2)
//                print(String(id)+" working")
//                sem.signal()
//            }
   
        var queue = OperationQueue()
        queue.name = "OperationQueue"
        queue.maxConcurrentOperationCount = 2
        
        var mainqueue = OperationQueue.main //Refers to the queue of the main thread
        
        queue.addOperation{
            print("1")
        }
        queue.addOperation{
            print("2")
        }
        
        let operation = BlockOperation(block: {
            print("operation1")
        })
        
        let operation2 = BlockOperation(block: {
            print("operation2")
        })
        
        operation.addDependency(operation2)
        queue.addOperation(operation)
        queue.addOperation(operation2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
