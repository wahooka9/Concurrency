//
//  NetworkViewController.swift
//  ConcurrencySwift
//
//  Created by Andrew Riznyk on 9/27/17.
//  Copyright © 2017 Andrew Riznyk. All rights reserved.
//

import UIKit

enum Result<Value> {
    case value(Value)
    case error(Error)
}

class Future<Value> {
    fileprivate var result: Result<Value>? {
        didSet { result.map(report) }
    }
    private lazy var callbacks = [(Result<Value>) -> Void]()
    
    func observe(with callback: @escaping (Result<Value>) -> Void) {
        callbacks.append(callback)
        result.map(callback)
    }
    
    private func report(result: Result<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()
        result = value.map(Result.value)
    }
    
    func resolve(with value: Value) {
        result = .value(value)
    }
    
    func reject(with error: Error) {
        result = .error(error)
    }
}

extension URLSession {
    func request(url: URL) -> Future<Data> {
        // Start by constructing a Promise, that will later be
        // returned as a Future
        let promise = Promise<Data>()
        
        // Perform a data task, just like normal
        let task = dataTask(with: url) { data, _, error in
            // Reject or resolve the promise, depending on the result
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }
        
        task.resume()
        
        return promise
    }
}


class NetworkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var operations = Dictionary<IndexPath,BlockOperation>();
    var queue = OperationQueue()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        queue.name = "OperationQueueNetwork"
        queue.maxConcurrentOperationCount = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension NetworkViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NetworkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "networkCell", for: indexPath) as! NetworkTableViewCell
        
        let operation = BlockOperation()
        weak var weakOperation = operation
        operation.addExecutionBlock { [unowned self] in
            let sessionWithoutADelegate = URLSession(configuration: .default)
            if let url = URL(string: imageArray[indexPath.row]) {
                (sessionWithoutADelegate.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                    } else if data != nil {
                        if let weakOp = weakOperation {
                        if (!(weakOp.isCancelled)){
                            DispatchQueue.main.async {
                                if (self.tableView.indexPathsForVisibleRows?.contains(indexPath))!{
                                    cell.networkImage.image = UIImage(data: data!)
                                }
                            }
                            self.operations.removeValue(forKey: indexPath)
                        }
                        }
                    }
                }).resume()
            }
        }
//        if let url = URL(string: imageArray[indexPath.row]){
//            URLSession.shared.request(url: url).observe { result in
//                print(result)
//            }
//        }
        
        operations.updateValue(operation, forKey: indexPath)
        
        queue.addOperation(operation)
        
        cell.networkImage.image = nil
        cell.indexLabelOutlet.text = "\(indexPath.row)"
        cell.informationLabelOutlet.text = "\(imageArray[indexPath.row])"
        

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let operation = self.operations[indexPath] {
            operation.cancel()
            operations.removeValue(forKey: indexPath)
        }
    }
    
}

