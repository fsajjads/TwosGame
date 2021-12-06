//
//  Tile.swift
//  Twos_Game
//
//  Created by Fahim Sajjad on 10/15/21.
//

import Foundation

struct Tile: Identifiable {

    var val : Int
    public var id = UUID()
    var row: Int    // recommended
    var col: Int

}
