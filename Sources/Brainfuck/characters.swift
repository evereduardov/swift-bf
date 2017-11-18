//
//  characters.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/5/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// BFCharacterSet
/// ADT - Sum Type
///
/// It has all the Unicode values of each BF instruction
///

enum BFCharacterSet {
    case RightArrow
    case LeftArrow
    case Plus
    case Minus
    case Dot
    case Comma
    case LeftSquareBracket
    case RightSquareBracket
    case Halt
    
    
    
    
    
    ///
    /// description :: BFCharacterSet -> String
    ///
    /// -return: The String representation of a BFCharacterSet
    ///
    
    var description: Character {
        switch self {
        case .RightArrow:
            return "\u{003E}"
        case .LeftArrow:
            return "\u{003C}"
        case .Plus:
            return "\u{002B}"
        case .Minus:
            return "\u{002D}"
        case .Dot:
            return "\u{002E}"
        case .Comma:
            return "\u{002C}"
        case .LeftSquareBracket:
            return "\u{005B}"
        case .RightSquareBracket:
            return "\u{005D}"
        default:
            // This is the unicode code point to character "\"
            // It is used for the Halt bitcode Strig representation.
            return "\u{002F}"
        }
    }
}


























