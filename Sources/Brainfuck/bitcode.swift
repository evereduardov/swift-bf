//
//  bitcode.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/6/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// BFBitcode
/// ADT - Sum Type
/// It has all the BF instructions.
/// In addition, it has a 'halt' instruction.
///

enum BFBitcode: UInt8 {
    case NextAddress
    case PreviousAddress
    case Add
    case Sub
    case Print
    case Input
    case Loop
    case EndLoop
    case Halt
    
    
    ///
    /// description :: BFBitcode -> String
    /// -return: A String representation of every bitcode.
    ///
    
    static func bc2String(code: UInt8) -> Character {
        switch code {
        case 0:
            return BFCharacterSet.RightArrow.description
        case 1:
            return BFCharacterSet.LeftArrow.description
        case 2:
            return BFCharacterSet.Plus.description
        case 3:
            return BFCharacterSet.Minus.description
        case 4:
            return BFCharacterSet.Dot.description
        case 5:
            return BFCharacterSet.Comma.description
        case 6:
            return BFCharacterSet.LeftSquareBracket.description
        case 7:
            return BFCharacterSet.RightSquareBracket.description
        default:
            return BFCharacterSet.Halt.description
        }
    }
}

























