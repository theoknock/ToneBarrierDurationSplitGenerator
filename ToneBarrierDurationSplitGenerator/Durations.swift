//
//  Durations.swift
//  ToneBarrierDurationSplitGenerator
//
//  Created by Xcode Developer on 5/17/24.
//

import Foundation
import Combine
import Observation

@Observable class Durations {
    var durationLength:     Double = 2.0000
    var durationLowerBound: Double = 0.3125
    var durationUpperBound: Double = 1.6875
    var durationTolerance:  Double = 0.3125
    
    init(length: Double?, lowerBound: Double?, upperBound: Double?, tolerance: Double?) {
        self.durationLength     = length     ?? durationLength
        self.durationLowerBound = lowerBound ?? durationLowerBound
        self.durationUpperBound = upperBound ?? durationUpperBound
        self.durationTolerance  = tolerance  ?? durationTolerance
        // Ensure the range is valid
        guard (durationUpperBound - durationLowerBound) >= durationTolerance else {
            fatalError("The range defined by durationLowerBound and durationUpperBound is too small for the given durationTolerance.")
        }
    }
    
    func scale(oldMin: CGFloat, oldMax: CGFloat, value: CGFloat, newMin: CGFloat, newMax: CGFloat) -> CGFloat {
        return newMin + ((newMax - newMin) * ((value - oldMin) / (oldMax - oldMin)))
    }
    
    // Generates randomized durations within these constraints:
    // durationLowerBound > []dyad0harmony0, dyad1harmony0] < durationUpperBound and |dyad0harmony0 - dyad1harmony0| >= durationTolerance
    let serialQueue = DispatchQueue(label: "com.example.serialQueue")
    
    public func randomizeDurationSplits(completion: @escaping ([[Double]]) -> Void) {
        serialQueue.async { [self] in
            let dyad0harmony0: Double = Double.random(in: durationLowerBound...durationUpperBound)
            var dyad1harmony0: Double = dyad0harmony0
            
            repeat {
                dyad1harmony0 = Double.random(in: durationLowerBound...durationUpperBound)
            } while (abs(dyad0harmony0 - dyad1harmony0) < durationTolerance)
            
            let dyad0harmony1 = durationLength - dyad0harmony0
            let dyad1harmony1 = durationLength - dyad1harmony0
            
            let result = [[dyad0harmony0, dyad0harmony1], [dyad1harmony0, dyad1harmony1]]
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    
    func numbers(count: Int) -> [[Float32]] {
        let allNumbers: [[Float32]] = ({ (operation: (Int) -> (() -> [[Float32]])) in
            operation(count)()
        })( { number in
            var channels: [[Float32]] = [Array(repeating: Float32.zero, count: count), Array(repeating: Float32.zero, count: count)]
            
            for i in 0..<count {
                channels[0][i] = Float32(i)
                channels[1][i] = Float32(i)
            }
                    
            return {
               channels
            }
        })
        print(allNumbers)
        
        return allNumbers
        
        // 'result' would be of type [[Int]] with the value [[5]]
        
        //                    accumulator.numbers(count: 31)
        
        //        return (operation: Int) -> [[Int]] {
        //
        //            return { return allNumbers }()
        //        }(0)
    }
}

//
//        return (b: Bool) -> Bool {
//            return (c: Bool) -> Bool {
//                return c
//            }((b == true))
//        }(a)
//    }
//}

//    func numbers(count: Int) -> [[Int]] {
//        var evenNumbers = Array(repeating: Int.zero, count: 31)
//        var oddNumbers = Array(repeating: Int.zero, count: 31)
//        var allNumbers: [[Int]] = [evenNumbers, oddNumbers]
//
//        (b: Bool) -> Bool {
//            {
//                return b
//            }({
//                print(b)
//            }())
//        }(false)
//
//        return { (operation: () -> Int) in
//            // Check if operation returns 0; if so, execute another block that returns 'allNumbers'
//            return (false && operation()) || (true & { return allNumbers }())
//        }({
//            var countdown: Int = count
//            for index in (0..<count).reversed() {
//                print(index)
//                countdown = index
//            }
//            return countdown  // Returning '0' after the countdown is completed
//        })
//    }
//
//
//    ^  (bool b){
//       ^ [[Int]] {
//           return allNumbers;
//       }()
//        return b;
//    }(TRUE)
//
//    ^ (bool b){
//        ^{
//            return b;
//        }()
//
//    }(FALSE)
//
//
//}

//        { (operation: (Int) -> Int, index: Int) in
//        (0..<count).reversed().map {
//            print($0)
//
//            return $0
//        }
//
//        { (count: Int) -> [[Int]] in  // Open outer closure
//            [
//                { (operation: (Int) -> Int, index: Int) in  // Open inner closure
//                    [operation(index)]
//                }( // Close parameters of inner closure
//                    operation: { number in  // Open operation closure
//                        number - 1  // Example decrement operation
//                    }, // Close operation closure
//                    index: count  // Pass 'count' as 'index'
//                 )
//            ]
//        }(count: 5)  // Close outer closure and invoke it with 'count' as 5
//
//
//
//        //
//                return { (operation: (Int) -> Int) in
//                    (0..<count).reversed().map {
//                        return operation($0) != 0 || { return allNumbers }()
//                    }({ index in
//                        print(index)
//                        while index != 0 {
//                            index = index - 1
//                        }
//                        return index
//                    })
//                }(count)

