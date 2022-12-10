//
//  main.swift
//  No rights reserved.
//

import Foundation

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }
    
    solve1(lines: lines)
    solve2(lines: lines)
}

func solve1(lines: [String]) {
    var visitedSquares: Set<String> = ["0,0"]
    var headX = 0
    var headY = 0
    var tailX = 0
    var tailY = 0
    
    lines.forEach { line in
        let (direction, steps) = parseLine(line)
        
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
            
            let newPos = calc(knot2: (x: tailX, y: tailY), basedOn: (x: headX, y: headY))
            tailX = newPos.x
            tailY = newPos.y
            
            visitedSquares.insert("\(tailX),\(tailY)")
        }
    }
    
    print(visitedSquares.count)

}

func calc(knot2: (x: Int, y: Int), basedOn knot: (x: Int, y: Int)) -> (x: Int, y: Int) {
    var newPos = knot2
    if knot.x - knot2.x > 1 {
        newPos.x += 1
        if knot.y - knot2.y > 0 {
            newPos.y += 1
        } else if knot.y - knot2.y < 0 {
            newPos.y -= 1
        }
    } else if knot.y - knot2.y > 1 {
        newPos.y += 1
        if knot.x - knot2.x > 0 {
            newPos.x += 1
        } else if knot.x - knot2.x < 0 {
            newPos.x -= 1
        }
    } else if knot.x - knot2.x < -1 {
        newPos.x -= 1
        if knot.y - knot2.y > 0 {
            newPos.y += 1
        } else if knot.y - knot2.y < 0 {
            newPos.y -= 1
        }
    } else if knot.y - knot2.y < -1 {
        newPos.y -= 1
        if knot.x - knot2.x > 0 {
            newPos.x += 1
        } else if knot.x - knot2.x < 0 {
            newPos.x -= 1
        }
    }
    return newPos
}

func solve2(lines: [String]) {
    var visitedSquares: Set<String> = ["0,0"]
    
    var knots: [(x: Int, y: Int)] = []
    for _ in 0..<10 {
        knots.append((x: 0, y: 0))
    }
    
    lines.forEach { line in
        let (direction, steps) = parseLine(line)
        for _ in 0..<steps {
            switch direction {
            case .up:
                knots[0].y += 1
            case .down:
                knots[0].y -= 1
            case .left:
                knots[0].x -= 1
            case .right:
                knots[0].x += 1
            }
            
            for i in 1..<10 {
                knots[i] = calc(knot2: knots[i], basedOn: knots[i-1])
            }

            visitedSquares.insert("\(knots[9].x),\(knots[9].y)")
        }
    }
    
    print(visitedSquares.count)
    
}

func printGrid(rows: Int, cols: Int, knots: [(x: Int, y: Int)]) {
    for row in 0..<rows {
        var rowString = ""
        for col in 0..<cols {
            if let index = knots.firstIndex(where: { $0.x == col && $0.y == row }) {
                let knot = index == 0 ? "H" : "\(index)"
                rowString += knot
            } else {
                rowString += "."
            }
        }
        print(rowString)
    }
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
