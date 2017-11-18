//
//  compiler.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/6/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// BFCompiler
/// It produces BF machine code.
/// This code is to be interpred by the BF virtual machile.
///

class BFCompiler {
    // Some fun here!
    static let header = "|--BRAINFUCK!--|"
    
    
    
    
    
    ///
    /// getHeaderList :: String -> [Bitcode]
    /// - return: The bitcode interpretation of the BFCompiler.headeer
    ///
    
    private static func getHeaderList(str: String) -> [Bitcode] {
        var result = [Bitcode]()
        
        for letter in header.unicodeScalars {
            if letter.isASCII {
                result.append(UInt8(ascii: letter))
            }
        }
        
        return result
    }
    
    
    
    
    
    ///
    /// areBracketsBalanced :: String -> Bool
    ///
    /// It thows an error when unbalanced brackets are found.
    /// -parameter sourceCode: The String representation of a BF program.
    /// -return: a boolean type for balanced or unbalanced brackets.
    ///
    
    static func areBracketsBalanced(sourceCode: String) throws -> Bool {
        let item = 0
        var stack = [Int]()
        
        for char in sourceCode {
            if char == BFCharacterSet.LeftSquareBracket.description {
                stack.append(item)
            } else if char == BFCharacterSet.RightSquareBracket.description {
                if !stack.isEmpty {
                    let _ = stack.popLast()
                } else {
                    throw BFError.EUnbalancedBrackets
                }
            }
        }
        
        if !stack.isEmpty {
            throw BFError.EUnbalancedBrackets
        }
        
        return true
    }
    
    
    
    
    
    ///
    /// decompile :: [Bitcode] -> String
    /// This is the inverse function of compile such that
    /// decompile(compile(source)) == source or
    /// compile(decompile(bitcode)) == bitcode
    ///
    
    static func decompile(bitcodes: [Bitcode]) -> String {
        var source = ""
        
        for bitcode in bitcodes {
            switch bitcode {
            case BFBitcode.NextAddress.rawValue:
                source.append(BFCharacterSet.RightArrow.description)
            case BFBitcode.PreviousAddress.rawValue:
                source.append(BFCharacterSet.LeftArrow.description)
            case BFBitcode.Add.rawValue:
                source.append(BFCharacterSet.Plus.description)
            case BFBitcode.Sub.rawValue:
                source.append(BFCharacterSet.Minus.description)
            case BFBitcode.Input.rawValue:
                source.append(BFCharacterSet.Comma.description)
            case BFBitcode.Print.rawValue:
                source.append(BFCharacterSet.Dot.description)
            case BFBitcode.Loop.rawValue:
                source.append(BFCharacterSet.LeftSquareBracket.description)
            case BFBitcode.EndLoop.rawValue:
                source.append(BFCharacterSet.RightSquareBracket.description)
            default:
                break
            }
        }
        
        return source
    }
    
    
    
    
    
    ///
    /// compile :: String -> [Bitcode]
    ///
    /// -parameter sourceCode: The String representation of a BF Algorithm
    /// -return: An array of type [Bitcode]
    ///
    
    static func compile(sourceCode: String) -> [Bitcode] {
        var bitcodes = BFCompiler.getHeaderList(str: BFCompiler.header)
        
        for char in sourceCode {
            switch char {
            case BFCharacterSet.RightArrow.description:
                bitcodes.append(BFBitcode.NextAddress.rawValue)
            case BFCharacterSet.LeftArrow.description:
                bitcodes.append(BFBitcode.PreviousAddress.rawValue)
            case BFCharacterSet.Plus.description:
                bitcodes.append(BFBitcode.Add.rawValue)
            case BFCharacterSet.Minus.description:
                bitcodes.append(BFBitcode.Sub.rawValue)
            case BFCharacterSet.Dot.description:
                bitcodes.append(BFBitcode.Print.rawValue)
            case BFCharacterSet.Comma.description:
                bitcodes.append(BFBitcode.Input.rawValue)
            case BFCharacterSet.RightSquareBracket.description:
                bitcodes.append(BFBitcode.EndLoop.rawValue)
            case BFCharacterSet.LeftSquareBracket.description:
                bitcodes.append(BFBitcode.Loop.rawValue)
            default:
                break
            }
        }
        
        bitcodes.append(BFBitcode.Halt.rawValue)
        
        return bitcodes
    }
}














