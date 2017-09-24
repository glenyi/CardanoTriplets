//
//  CardanoTripletViewController.swift
//  Cardano Swift
//
//  Created by Glen Yi on 2014-08-21.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

import UIKit

typealias Triplet = (a: UInt, b: UInt, c: UInt)

func isCardanoTriplet(_ triplet: Triplet) -> Bool {
    let a = Double(triplet.a)
    let bc = Double(triplet.b) * Double(triplet.c).squareRoot()
    let cardano = cbrt(a+bc) + cbrt(a-bc)

    // Float errors... if there's a better way then please let me know
    return (cardano < 1.00000000001 && cardano > 0.9999999999)
}

class CardanoTripletViewController: UIViewController {
                            
    @IBOutlet private var limitTextField: UITextField!
    @IBOutlet private var goButton: UIButton!
    @IBOutlet private var tripletsLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleClickedGo(_ sender: UIButton) {
        // Find all cardano triplets
        guard let limit = UInt(limitTextField.text ?? ""),
            limit >= 3 else {
                return
        }

        // Retrieve current time
        let timestamp = NSDate()

        // UI updates
        timeLabel.text = "Calculating..."
        goButton.isEnabled = false
        limitTextField.isEnabled = false

        calculateTriplets(withLimit: limit, completion: { count in
            // Update triplets and time in seconds
            self.tripletsLabel.text = "\(count)"
            let seconds = -timestamp.timeIntervalSinceNow
            let secondsString = String(format: "%.2f", seconds)
            self.timeLabel.text = "\(secondsString)"

            // UI updates
            self.goButton.isEnabled = true
            self.limitTextField.isEnabled = true
            print("Found \(count) triplets in \(secondsString) seconds!")
        } )
    }
    
    private func calculateTriplets(withLimit limit: UInt, completion: @escaping (UInt)->()) {
        // Calculate the triplets asynchronously
        DispatchQueue.global(qos: .userInitiated).async {
            var count: UInt = 0

            // Here is where most of the computing time happens, a brute force solution.
            // I'm sure there are some very elegant mathematical simplifications here but
            // that's beyond the scope of this exercise.
            for a: UInt in 1...(limit-2) {
                for b: UInt in 1...(limit-a-1) {
                    for c: UInt in 1...(limit-a-b) {
                        let triplet = (a, b, c)
                        if isCardanoTriplet(triplet) {
                            count += 1
                            print("\(count): \(triplet)")
                        }
                    }
                }
            }

            DispatchQueue.main.async {
                completion(count)
            }
        }
    }

}


