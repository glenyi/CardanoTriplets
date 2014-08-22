//
//  ViewController.swift
//  Cardano Swift
//
//  Created by Glen Yi on 2014-08-21.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var limitTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var tripletsLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    typealias Triplet = (a: Int, b: Int, c: Int)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goClick(sender: UIButton) {
        // Find all cardano triplets
        if let limit = limitTextField.text.toInt() {
            if limit >= 3 {
                // Retrieve current time
                let timestamp = NSDate()
                
                // UI updates
                self.timeLabel.text = "Calculating..."
                self.goButton.enabled = false
                self.limitTextField.enabled = false
                
                self.calculateTriplets(limit, { count in
                    // Update triplets and time in seconds
                    self.tripletsLabel.text = "\(count)"
                    let seconds = -timestamp.timeIntervalSinceNow
                    self.timeLabel.text = "\(Int(seconds))"
                    
                    // UI updates
                    self.goButton.enabled = true
                    self.limitTextField.enabled = true
                    println("Found \(count) triplets in \(Int(seconds)) seconds!")
                } )
            }
        }
    }
    
    func isCardanoTriplet(triplet: Triplet) -> Bool {
        let bc = Double(triplet.b) * sqrt(Double(triplet.c))
        let cardano = cbrt(Double(triplet.a)+bc) + cbrt(Double(triplet.a)-bc)
        
        // Float errors... if there's a better way then please let me know
        let isCardano = (cardano < 1.00000000000001 && cardano > 0.99999999999999)
        
        return isCardano
    }
    
    func calculateTriplets(limit: Int, completion: (Int)->()) {
        // Calculate the triplets asynchronously
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            var count = 0
            
            // Here is where most of the computing time happens, a brute force solution.
            // I'm sure there are some very elegant mathematical simplifications here but that's beyond the scope of this exercise.
            for a in 1...limit-2 {
                for b in 1...limit-a-1 {
                    for c in 1...(limit-a-b) {
                        let triplet = (a, b, c)
                        if self.isCardanoTriplet(triplet) {
                            count++
                            println("\(count): \(triplet)")
                        }
                    }
                }
            }
            
            // Return results on main thread
            dispatch_sync(dispatch_get_main_queue(), {
                completion(count)
            })
        })
    }

}

