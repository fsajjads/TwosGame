//
//  model.swift
//  Twos_Game
//
//  Created by Fahim Sajjad on 10/15/21.
//

import Foundation

class Twos: ObservableObject {

    @Published var board: [[Tile]] =  Array(repeating: Array(repeating: Tile(val: 0, row:0, col: 0) , count: 4), count: 4)
    @Published var scorelist: [Score]
    @Published var score: Int
    var mode: Bool
    var seededGenerator:SeededGenerator
    var generator : SeededGenerator
    
    init() {
        self.score = 0
        self.mode = false
        self.seededGenerator = SeededGenerator(seed: 14)
        self.generator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
        scorelist = [Score(score: 300, time: Date()), Score(score: 400, time: Date())]
        
        for i in 0...3{
            for j in 0...3{
                board[i][j] = Tile(val: 0, row: i, col: j)
                
            }
    
        }
        
    }

    
    func sortScoreList() -> [Score]{
        return scorelist.sorted{
            $0.score > $1.score
        }
     
    }
    
   
    func shiftLeft() -> Bool {
        let check1 = fill_blank()
        let check2 = merge()
        let is_mod = fill_blank()
        if(check1 == true || check2 == true || is_mod == true){
            return true
        }else{
            return false
        }
    }
    // collapse to the left
    func rightRotate()   {
       board = rotate2D(input: board)
    }
    
    // define using only rotate2D
    func collapse(dir: Direction) -> Bool{
        
        switch dir{
        case .left:
            let is_mod =  shiftLeft()
            return is_mod
           case .right:
            rightRotate()
            rightRotate()
            let is_mod = shiftLeft()
          rightRotate()
          rightRotate()
        return is_mod
        case .up:
           
            rightRotate()
            rightRotate()
            rightRotate()
           let  is_mod =  shiftLeft()
            rightRotate()
            return is_mod
        case .down:
            rightRotate()
            let  is_mod  = shiftLeft()
            rightRotate()
            rightRotate()
            rightRotate()
            return is_mod
            
        }
    }                     // collapse in direction "dir" using only
                                                       // shiftLeft() and rightRotate()
  
   
    func newgame(rand: Bool){
        mode = rand
        
        for i in 0...3{
            for j in 0...3{
                board[i][j] = Tile(val: 0, row: i, col: j)
            }
    
        }
        score = 0
        seededGenerator = SeededGenerator(seed: 14)
        generator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
    }
    
    
    
    
    func spawn(){
        
        if mode == false{
            
            var newRandomNumber = Int.random(in: 1...2, using: &seededGenerator)
            newRandomNumber  = newRandomNumber * 2;
            
            let indexes: Int =  empty_index(input: board)
           
            let newRandomIndex: Int = Int.random(in: 0...indexes, using: &seededGenerator )
            
            var check = 0
            for i in 0...3 {
                for j in 0...3{
                    if(board[i][j].val == 0) {
                     if (check == newRandomIndex){
                         board[i][j].val = newRandomNumber
                     }
                     check = check + 1
                 }
               }
            }
     
        
            
            
        }else{

            var newRandomNumber = Int.random(in: 1...2, using: &generator)
            newRandomNumber  = newRandomNumber * 2;
            
            let indexes: Int =  empty_index(input: board)
           
            let newRandomIndex: Int = Int.random(in: 0...indexes, using: &generator )
            
            var check = 0
            for i in 0...3 {
                for j in 0...3{
                    if(board[i][j].val == 0) {
                     if (check == newRandomIndex){
                         board[i][j].val =  newRandomNumber
                     }
                     check = check + 1
                 }
               }
            }
     
        
         
        }
    }
    
    
    
    func fill_blank() -> Bool {
    var count = 0
    var is_empty: Bool = false
    var check = 0
   
       for i in 0...board.count - 1 {
           for j in 0...board.count - 2 {
               if(board[i][j].val == 0) {
                   count = count + 1
                  check = j
                   while(check <= 3 && is_empty == false ) {
                       if(board[i][check].val != 0) {
                             is_empty = true;
                        }
                     check += 1;
                 }
                   
                   if( is_empty == true) {
                       board[i][j] = Tile(val: board[i][check - 1].val,  row:i, col:j)
                       board[i][check - 1] = Tile(val: 0,  row:i, col: check - 1)
                    }
                       check = 0;
                       is_empty = false;
                    
               }
          }
       }
        
        if (count == 0){
            return false
        }else{
            return true
        }
   }
    
    
    func merge() ->Bool {
        var check = 0
        var count = 0
       for i in 0...board.count - 1 {
           for j in 0...board.count - 2 {
            if(board[i][j].val == board[i][j+1].val) {
                check = check  + 1
                count =  board[i][j].val * 2
                board[i][j] = Tile(val: count, row:i, col: j );
                score = score + count
                board[i][j+1] = Tile(val: 0, row:i, col: j + 1);
            }
          }
       }
        
        return check == 0 ? false : true
    }
    
    func game_ended(input: Twos) -> Bool{
        
        if(input.collapse(dir: .left) == true || input.collapse(dir: .right) == true || input.collapse(dir: .right) == true ||
           input.collapse(dir: .up) == true || input.collapse(dir:.down) == true){
            return false
        }else{
            return true
        }
                 
}



enum Direction {
       case left
       case right
       case up
       case down
    }
    
// primitive functions
public func rotate2DInts(input: [[Int]]) ->[[Int]] {
    var arr: [[Int]] = Array(repeating: Array(repeating:0, count: 4), count: 4)
    for i in 0...input.count - 1 {
        for j in 0...input.count - 1 {
            arr[j][input.count - 1 - i] = input[i][j]
           }
       }
    return arr
}// rotate a square 2D Int array clockwise

public func rotate2D(input: [[Tile]]) ->[[Tile]] {
    var arr = input
    for i in 0...input.count - 1 {
        for j in 0...input.count - 1 {
            arr[j][input.count - 1 - i] = Tile(val: input[i][j].val, row:j, col: input.count - 1 - i )
           }
       }
    return arr
    
}     // generic version of the above

    // high-level functions





func empty_index(input: [[Tile]]) -> Int {
    var count = 0
       for i in 0...3 {
           for j in 0...3{
               if(input[i][j].val == 0) {
                count = count + 1
            }
          }
       }
     return count - 1
}


}

struct Score: Hashable {
    var score: Int
    var time: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
}
