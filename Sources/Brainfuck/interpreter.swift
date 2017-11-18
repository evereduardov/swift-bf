//
//  interpreter.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/7/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// class BFInterpreter
/// Static Class
///
/// It runs BF code from the BF-REPL.
///

class BFInterpreter {
    
    
    
    
    
    ///
    /// runCodeFromREPL :: [Bitcode] -> inout [Cell] -> inout Index -> inout Index -> BFExitCode
    ///
    /// -parameter code: The bitcode compiled from every REPL line.
    /// -parameter tape: It is an inout value. It is the Hardware where the code runs.
    /// -parameter tapeIndex: The current index of the tape.
    /// -parameter instructionPointer: The current index in the BF bitcode array.
    /// -return: BFExitCode
    ///
    
    static func runCodeFromREPL(code: [Bitcode],
                            tape: inout [Cell],
                            tapeIndex: inout Array<Cell>.Index,
                            maxKnownIndex: inout Int,
                            loopStack: inout [Int],
                            debug: Bool) throws -> BFExitCode {
        
        var instructionPointer = code.startIndex.advanced(by: BFCompiler.header.count)
        
        var bitcode = code[instructionPointer]
        
        var step = 1
        
        
        while bitcode != BFBitcode.Halt.rawValue {
            
            // for step by step computation.
            if debug {
                let bc2str = BFBitcode.bc2String(code: bitcode)
                let prompt = "\n\n        Step ❮ \(step) ❯   𝝣   BF Command ❮ \(bc2str) ❯".foregroundColor(.yellow2).italic()
                print(prompt, separator: "", terminator: "")
                let _ = readLine(strippingNewline: true)
            }
            
            switch bitcode {
            case BFBitcode.NextAddress.rawValue:
                if tapeIndex.advanced(by: 1) == tape.endIndex {
                    tape.append(contentsOf: BFVirtualMachine.createTape(amountOfCells: BFVirtualMachine.addedTapeSize))
                }
                
                tapeIndex = tapeIndex.advanced(by: 1)
                
                if tapeIndex > maxKnownIndex {
                    maxKnownIndex = tapeIndex
                }
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
                if debug {
                    break
                }
                
                if tape[tapeIndex] < 0 || tape[tapeIndex] > UInt32.max {
                    throw BFError.EUnicodeScalarOutOfRange
                } else {
                    let unicode = UnicodeScalar(tape[tapeIndex])
                    if let _ = unicode {
                        let char = Character(unicode!)
                        print(String(char).bold(), separator: "", terminator: "")
                    } else {
                        throw BFError.EUnicodeNilValue
                    }
                }
            case BFBitcode.Input.rawValue:
                var input = BFIo.readLineFromTerminal(prompt: "\n\n        ❮┅   ".green())
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
            
            
            
            
            ///
            /// Prints the result of every step computation
            /// It is used in debug mode only.
            ///
            
            if debug {
                let prompt = "               ∴ ".foregroundColor(.orange3).italic().bold()
                var newState = " "
                switch bitcode {
                case BFBitcode.NextAddress.rawValue:
                    newState += " New Index State ⊨ ".foregroundColor(.orange3).italic().bold()
                    newState += tapeIndex.description.foregroundColor(.orange3).italic().bold()
                    newState += "\n                   "
                    newState += tape[...maxKnownIndex].description.foregroundColor(.orange3).italic().bold()
                    print(prompt + newState)
                case BFBitcode.PreviousAddress.rawValue:
                    newState += " New Index State ⊨ ".foregroundColor(.orange3).italic().bold()
                    newState += tapeIndex.description.foregroundColor(.orange3).italic().bold()
                    newState += "\n                   "
                    newState += tape[...maxKnownIndex].description.foregroundColor(.orange3).italic().bold()
                    print(prompt + newState)
                case BFBitcode.Add.rawValue:
                    newState += " New Cell [\(tapeIndex)] State ⊨ ".foregroundColor(.orange3).italic().bold()
                    newState += tape[tapeIndex].description.foregroundColor(.orange3).italic().bold()
                    newState += "\n                   "
                    newState += tape[...maxKnownIndex].description.foregroundColor(.orange3).italic().bold()
                    print(prompt + newState)
                case BFBitcode.Sub.rawValue:
                    newState += " New Cell [\(tapeIndex)] State ⊨ ".foregroundColor(.orange3).italic().bold()
                    newState += tape[tapeIndex].description.foregroundColor(.orange3).italic().bold()
                    newState += "\n                   "
                    newState += tape[...maxKnownIndex].description.foregroundColor(.orange3).italic().bold()
                    print(prompt + newState)
                case BFBitcode.Print.rawValue:
                    newState += " Print Cell [\(tapeIndex)] ⊨ ".foregroundColor(.orange3).italic().bold()
                    newState += String(Character(UnicodeScalar(tape[tapeIndex])!)).foregroundColor(.orange3).italic().bold()
                    newState += "\n                   "
                    newState += tape[...maxKnownIndex].description.foregroundColor(.orange3).italic().bold()
                    print(prompt + newState)
                case BFBitcode.Input.rawValue:
                    newState += " Input Cell [\(tapeIndex)] ⊨ ".foregroundColor(.orange3).italic().bold()
                    newState += String(Character(UnicodeScalar(tape[tapeIndex])!)).foregroundColor(.orange3).italic().bold()
                    newState += "\n                   "
                    newState += tape[...maxKnownIndex].description.foregroundColor(.orange3).italic().bold()
                    print(prompt + newState)
                case BFBitcode.Loop.rawValue:
                    newState += " Loop ⊨ ".foregroundColor(.orange3).italic().bold()
                    if tape[tapeIndex] != 0 {
                        newState += "True".foregroundColor(.orange3).italic().bold()
                    } else {
                        newState += "False".foregroundColor(.orange3).italic().bold()
                    }
                    newState += "\n                   "
                    newState += tape[...maxKnownIndex].description.foregroundColor(.orange3).italic().bold()
                    print(prompt + newState)
                case BFBitcode.EndLoop.rawValue:
                    newState += " EndLoop ⊨ ".foregroundColor(.orange3).italic().bold()
                    if tape[tapeIndex] != 0 {
                        newState += "False".foregroundColor(.orange3).italic().bold()
                    } else {
                        newState += "True".foregroundColor(.orange3).italic().bold()
                    }
                    newState += "\n                   "
                    newState += tape[...maxKnownIndex].description.foregroundColor(.orange3).italic().bold()
                    print(prompt + newState)
                default:
                    break
                }
            }
            
            
            
            
            
            ///
            /// Here every thing is updated.
            ///
            
            step = step.advanced(by: 1)
            instructionPointer = instructionPointer.advanced(by: 1)
            bitcode = code[instructionPointer]
        }
        
        
        ///
        /// Debug log
        ///
        
        if debug {
            step = step.advanced(by: -1)
            var prompt = "\n\n        The step by step computation has finished!".foregroundColor(.yellow2).italic()
            prompt += "\n            Total Steps Needed = \(step)".foregroundColor(.yellow2).italic()
            var finalState = "\n            Final BF State:".foregroundColor(.orange3).italic().bold()
            finalState += "\n\n            Index           =   \(tapeIndex)".foregroundColor(.lightCyan1).italic()
            finalState += "\n            MaxKnownIndex   =   \(maxKnownIndex)".foregroundColor(.lightCyan1).italic()
            finalState += "\n            Cell [\(tapeIndex)]        =   \(tape[tapeIndex])".foregroundColor(.lightCyan1).italic()
            finalState += "\n            \(tape[...maxKnownIndex])\n\n".foregroundColor(.lightCyan1).italic()
            print(prompt + finalState)
        }
        
        
        
        
        return BFExitCode.Success
    }
}















