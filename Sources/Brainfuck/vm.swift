//
//  vm.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/6/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// Global Typealiases
/// Cell    :: Int
/// Bitcode :: UInt8
///

typealias Cell      = Int
typealias Bitcode   = UInt8





///
/// BFVirtualMachine
/// Static Class
///
///

class BFVirtualMachine {
    static let tapeSize = 30_000
    static let addedTapeSize = 10_000
    
    
    
    
    
    ///
    /// createTape :: Int -> [Cell]
    ///
    /// Every cell is initialized to Zero.
    /// -parameter amoutOfCells:
    /// -return: An array type [Cell]
    ///
    
    static func createTape(amountOfCells: Int) -> [Cell] {
        precondition(amountOfCells > 0, "Paramenter amountOfCells should be a positive integer.")
        
        var tape = [Cell]()
        for _ in 0..<amountOfCells {
            tape.append(0)
        }
        
        return tape
    }
    
    
    
    
    
    ///
    /// checkBitcodes :: [Bitcode] -> Bool
    ///
    
    static func checkBitcodes(bitcodes: [Bitcode]) -> Bool {
        var id = ""
        
        for idx in 0..<16 {
            id.append(Character(UnicodeScalar(bitcodes[idx])))
        }
        
        return id == BFCompiler.header
    }
    
    
    
    
    
    ///
    /// runBitcode :: [Bitcode] -> BFExitCode
    ///
    
    static func runBitcode(code: [Bitcode]) throws -> BFExitCode {
        var tape = BFVirtualMachine.createTape(amountOfCells: BFVirtualMachine.tapeSize)
        var tapeIndex = tape.startIndex
        
        
        
        // Check for file format
        if !BFVirtualMachine.checkBitcodes(bitcodes: code) {
            throw BFError.ERunTimeUnknownBitcodeFileFormat
        }
        
        
        
        var instructionPointer = code.startIndex.advanced(by: BFCompiler.header.count)
        var bitcode = code[instructionPointer]
        var loopStack = [Int]()
        
        
        
        ///
        /// Main VM cycle: Fectch, decode, interpret, loop
        ///
        
        while bitcode != BFBitcode.Halt.rawValue {
            switch bitcode {
            case BFBitcode.NextAddress.rawValue:
                if tapeIndex.advanced(by: 1) == tape.endIndex {
                    tape.append(contentsOf: BFVirtualMachine.createTape(amountOfCells: BFVirtualMachine.addedTapeSize))
                }
                tapeIndex = tapeIndex.advanced(by: 1)
            case BFBitcode.PreviousAddress.rawValue:
                if tapeIndex == tape.startIndex {
                    throw BFError.EIndexOutOfRange
                }
                tapeIndex = tapeIndex.advanced(by: -1)
            case BFBitcode.Add.rawValue:
                if tape[tapeIndex] != Int.max {
                    tape[tapeIndex] = tape[tapeIndex].advanced(by: 1)
                } else {
                    tape[tapeIndex] = Int.min
                }
            case BFBitcode.Sub.rawValue:
                if tape[tapeIndex] != Int.min {
                    tape[tapeIndex] = tape[tapeIndex].advanced(by: -1)
                } else {
                    tape[tapeIndex] = Int.max
                }
            case BFBitcode.Print.rawValue:
                if tape[tapeIndex] < 0 || tape[tapeIndex] > UInt32.max {
                    throw BFError.EUnicodeScalarOutOfRange
                } else {
                    let unicode = UnicodeScalar(tape[tapeIndex])
                    if let _ = unicode {
                        let char = Character(unicode!)
                        print(char, separator: "", terminator: "")
                    } else {
                        throw BFError.EUnicodeNilValue
                    }
                }
            case BFBitcode.Input.rawValue:
                var input = BFIo.readLineFromTerminal(prompt: "")
                if !input.isEmpty {
                    let char = input.remove(at: input.startIndex)
                    tape[tapeIndex] = Int(bitPattern: UInt(char.unicodeScalars.first!.value))
                }
            case BFBitcode.Loop.rawValue:
                if tape[tapeIndex] == 0 {
                    loopLoop: while true {
                        if bitcode == BFBitcode.Loop.rawValue {
                            loopStack.append(instructionPointer)
                            instructionPointer = instructionPointer.advanced(by: 1)
                            bitcode = code[instructionPointer]
                        } else if bitcode == BFBitcode.EndLoop.rawValue {
                            let _ = loopStack.popLast()
                            if loopStack.isEmpty {
                                break loopLoop
                            } else {
                                instructionPointer = instructionPointer.advanced(by: 1)
                                bitcode = code[instructionPointer]
                            }
                        } else {
                            instructionPointer = instructionPointer.advanced(by: 1)
                            bitcode = code[instructionPointer]
                        }
                    }
                } else {
                    loopStack.append(instructionPointer)
                }
            case BFBitcode.EndLoop.rawValue:
                if tape[tapeIndex] != 0 {
                    instructionPointer = loopStack.last!
                    bitcode = code[instructionPointer]
                } else {
                    let _ = loopStack.popLast()
                }
            default:
                break
            }
            
            instructionPointer = instructionPointer.advanced(by: 1)
            bitcode = code[instructionPointer]
        }
        
        return BFExitCode.Success
    }
}





///
/// BFExitCode
/// ADT - Sum Type
///
/// It represents the computational result
/// of the BF Virtual Machine, and some
/// other functions.
/// It was used during the development of BF interpreter/repl
///

enum BFExitCode: CustomStringConvertible {
    case Success
    case Failure
    
    var description: String {
        switch self {
        case .Success:
            return "Success!"
        default:
            return "Failure!"
        }
    }
}


















