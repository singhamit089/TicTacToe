//
//  TicTacToe.swift
//  TicTacToe
//
//  Created by Amit  Singh on 9/20/18.
//  Copyright © 2018 singhamit089. All rights reserved.
//

import Foundation

class TicTacToe {
    
    let boardSize:Int!
    
    var matrix:[[Int]]
    
    var lastMove:InputType!
    
    var ifFirstMovePlayed = false
    
    var gameWon = false
    
    init(boardSize:Int){
        self.boardSize = boardSize
        self.matrix = Array(repeating: Array(repeating: -1, count: boardSize), count: boardSize)
        lastMove = InputType.l
    }
    
    func userInput(with input:Input) {
        
        var currentMove:InputType = input.type
        let cordinates = input.coridnates
        
        if lastMove == InputType.l {
            currentMove = InputType.X
        }
        
        lastMove = currentMove
        
        self.matrix[input.coridnates.xCordinates][input.coridnates.yCordinates] = currentMove.rawValue
        
        gameWon = checkIfAWin(for: Input(coridnates: cordinates, type: currentMove))
    }
    
    func checkIfAWin(for input:Input) -> Bool {
        
        lastMove = input.type == .X ? .O : .X
        
        var allColumnSame = true
        var allRowSame = true
        var rightDiagonalsSame = true
        var leftDiagonalsSame = true
        
        for i in 0..<boardSize {
            
            if ( matrix[input.coridnates.xCordinates][i] != input.type.rawValue) && allRowSame {
                allRowSame = false
            }
            if (matrix[i][input.coridnates.yCordinates] != input.type.rawValue) && allColumnSame{
                allColumnSame = false
            }
            if(matrix[i][i] != input.type.rawValue) && rightDiagonalsSame{
                rightDiagonalsSame = false
            }
            if(matrix[i][(boardSize-1)-i] != input.type.rawValue) && leftDiagonalsSame{
                leftDiagonalsSame = false
            }
        }
        
        gameWon = allColumnSame || allRowSame || rightDiagonalsSame || leftDiagonalsSame
        
        if gameWon {
            NotificationCenter.default.post(name: NSNotification.Name("userWonTheGame"), object: nil)
        }
        
        return gameWon
    }
}

enum InputType:Int {
    case X = 1
    case O = 0
    case l = -1
}

struct Cordinates {
    
    var xCordinates:Int
    var yCordinates:Int
    
    init(xCordinates:Int,yCordinates:Int) {
        self.xCordinates = xCordinates
        self.yCordinates = yCordinates
    }
}

struct Input {
    var coridnates:Cordinates
    var type:InputType
    
    init(coridnates:Cordinates,type:InputType) {
        self.coridnates = coridnates
        self.type = type
    }
}
