//
//  WordSearch.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/10/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

enum PlacementType: CaseIterable {
    case leftRight
    case rightLeft
    case upDown
    case downUp
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft

    var movement: (x: Int, y: Int) {
        switch self {
        case .leftRight:
            return (1, 0)
        case .rightLeft:
            return (-1, 0)
        case .upDown:
            return (0, 1)
        case .downUp:
            return (0, -1)
        case .topLeftBottomRight:
            return (1, 1)
        case .topRightBottomLeft:
            return (-1, 1)
        case .bottomLeftTopRight:
            return (1, -1)
        case .bottomRightTopLeft:
            return (-1, -1)
        }
    }
}


enum Difficulty {
    case easy
    case medium
    case hard

    var placementTypes: [PlacementType] {
        switch self {
        case .easy:
            return [.leftRight, .upDown].shuffled()

        case .medium:
            return [.leftRight, .rightLeft, .upDown, .downUp].shuffled()

        case .hard:
            return PlacementType.allCases.shuffled()
        }
    }
}

class Label {
    var letter: Character = " "
}


class WordSearch {
    var difficulty: Difficulty

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
    }

    var words = [Word]()
    var gridSize = 10

    var labels = [[Label]]()

    let allLetters = (65...90).map { Character(Unicode.Scalar($0)) }

    func createGrid() {
        labels = (0 ..< gridSize).map { _ in
            (0 ..< gridSize).map { _ in Label() }
        }

        _ = placeWords()
        fillGaps()
//        printGrid()
    }

    private func fillGaps() {
        for column in labels {
            for label in column {
                if label.letter == " " {
                    label.letter = allLetters.randomElement()!
                }
            }
        }
    }

    func printGrid() {
        for column in labels {
            for row in column {
                print(row.letter, terminator: "")
            }

            print("")
        }
    }

    private func labels(fromX x: Int, y: Int, word: String, movement: (x: Int, y: Int)) -> [Label]? {
        var returnValue = [Label]()

        var xPosition = x
        var yPosition = y

        for letter in word {
            let label = labels[xPosition][yPosition]

            if label.letter == " " || label.letter == letter {
                returnValue.append(label)
                xPosition += movement.x
                yPosition += movement.y
            } else {
                return nil
            }
        }

        return returnValue
    }

    private func tryPlacing(_ word: String, movement: (x: Int, y: Int)) -> Bool {
        let xLength = (movement.x * (word.count - 1))
        let yLength = (movement.y * (word.count - 1))

        let rows = (0 ..< gridSize).shuffled()
        let cols = (0 ..< gridSize).shuffled()

        for row in rows {
            for col in cols {
                let finalX = col + xLength
                let finalY = row + yLength

                if finalX >= 0 && finalX < gridSize && finalY >= 0 && finalY < gridSize {
                    if let returnValue = labels(fromX: col, y: row, word: word, movement: movement) {
                        for (index, letter) in word.enumerated() {
                            returnValue[index].letter = letter
                        }

                        return true
                    }
                }
            }
        }

        return false
    }

    private func place(_ word: Word) -> Bool {
        let formattedWord = word.text.replacingOccurrences(of: " ", with: "").uppercased()

        return difficulty.placementTypes.contains {
            tryPlacing(formattedWord, movement: $0.movement)
        }
    }

    private func placeWords() -> [Word] {
        return words.shuffled().filter(place)
    }
}
