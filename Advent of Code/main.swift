//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }
    
    var visitedSquares: Set<String> = ["0,0"]
    var headX = 0
    var headY = 0
    var tailX = 0
    var tailY = 0
    
    lines.forEach { line in
        let (direction, steps) = parseLine(line)
//        print(direction, steps)
        
        for _ in 0..<steps {
            switch direction {
            case .up:
                headY += 1
            case .down:
                headY -= 1
            case .left:
                headX -= 1
            case .right:
                headX += 1
            }
            
            if headX - tailX > 1 {
                tailX += 1
                if headY - tailY > 0 {
                    tailY += 1
                } else if headY - tailY < 0 {
                    tailY -= 1
                }
            }
            if headY - tailY > 1 {
                tailY += 1
                if headX - tailX > 0 {
                    tailX += 1
                } else if headX - tailX < 0 {
                    tailX -= 1
                }
            }
            
            if headX - tailX < -1 {
                tailX -= 1
                if headY - tailY > 0 {
                    tailY += 1
                } else if headY - tailY < 0 {
                    tailY -= 1
                }
            }
            if headY - tailY < -1 {
                tailY -= 1
                if headX - tailX > 0 {
                    tailX += 1
                } else if headX - tailX < 0 {
                    tailX -= 1
                }
            }
            
//            print("\nHEAD: ", headX, headY)
//            print("TAIL: ", tailX, tailY)
            visitedSquares.insert("\(tailX),\(tailY)")
        }
    }
    
    print(visitedSquares.count)
}

enum Direction: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
}

func parseLine(_ line: String) -> (direction: Direction, steps: Int) {
    let results = line.components(separatedBy: .whitespaces)
    return (Direction(rawValue: results[0])!, Int(results[1])!)
}

let startTime = Date()
main()
let timeElapsed = Date().timeIntervalSince(startTime) * 1000
print("elapsed: \(timeElapsed)ms")
