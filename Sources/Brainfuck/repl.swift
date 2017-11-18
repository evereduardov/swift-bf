//
//  repl.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/5/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// BFRepl
/// Static Class
///
/// It has the BF REPL.
///

class BFRepl {
    private static var tapeSize = BFVirtualMachine.tapeSize
    private static var tape = BFVirtualMachine.createTape(amountOfCells: tapeSize)
    private static var index = tape.startIndex
    private static var maxKnownIndex = index // It is for printing and reset efficiency.
    private static var feedback = false
    internal static var debug = false
    private static var continuous = true
    private static var loadedFile = ""
    private static var loopStack = [Int]()
    
    
    
    
    
    // It prints the Tape on the terminal screen.
    // It does not print every single cell, but
    // it only prints from index 0 to maxKnownIndex
    private static func printTape() -> Void {
        if maxKnownIndex.advanced(by: 1) < tape.endIndex {
            print("\n        \(tape.prefix(maxKnownIndex.advanced(by: 1)))".foregroundColor(.lightCyan1).italic())
        } else {
            print("\n        \(tape)".foregroundColor(.lightCyan1).italic())
        }
    }
    
    
    
    
    
    // Print Cell at Index
    private static func printCellStateAtCurrentIndex() -> Void {
        print("\n        Cell [\(index)]        =  \(tape[index])".foregroundColor(.lightCyan1).italic())
    }
    
    
    
    
    
    // It prints the current index
    private static func printCurrentIndex() -> Void {
        print("\n        Index           =  \(index)".foregroundColor(.lightCyan1).italic())
        print("\n        MaxKnownIndex   =  \(maxKnownIndex)".foregroundColor(.lightCyan1).italic())
    }
    
    
    
    
    
    // It resets the tape
    // from Index 0 to maxKnownIndex to
    // its initial state value which is zero.
    private static func resetTape() -> Void {
        if maxKnownIndex == tape.endIndex {
            for i in 0..<maxKnownIndex {
                tape[i] = 0
            }
        } else if maxKnownIndex < tape.endIndex {
            for i in 0...maxKnownIndex {
                tape[i] = 0
            }
        } else {
            for i in 0..<tape.endIndex {
                tape[i] = 0
            }
        }
        
        index = tape.startIndex
        maxKnownIndex = index
        loopStack.removeAll()
        loadedFile = ""
    }
    
    
    
    
    
    // It prints the current computation state
    private static func printFeedBack() -> Void {
        print("\n\n")
        BFRepl.printCurrentIndex()
        BFRepl.printCellStateAtCurrentIndex()
        BFRepl.printTape()
        print("\n\n")
    }
    
    
    
    
    
    // It prints the Current Computation State
    // plus other repl information
    private static func printInfo() -> Void {
        print("\n\n")
        BFRepl.printCurrentIndex()
        BFRepl.printCellStateAtCurrentIndex()
        BFRepl.printTape()
        print("\n        Feedback        =  ".foregroundColor(.lightCyan1).italic() + ((feedback) ? "on" : "off").foregroundColor(.lightCyan1).italic())
        print("\n        Continuous      =  ".foregroundColor(.lightCyan1).italic() + ((continuous) ? "on" : "off").foregroundColor(.lightCyan1).italic())
        print("\n        Debug           =  ".foregroundColor(.lightCyan1).italic() + ((debug) ? "on" : "off").foregroundColor(.lightCyan1).italic())
        print("\n\n")
    }
    
    
    
    
    
    //
    // loadFile :: String -> Void
    //
    private static func loadFile(input: String) throws -> Void {
        let list = input.split(separator: " ")
        
        if list.count == 1 {
            print("\n\n\n\n       ✖︎   Error:".foregroundColor(.red3).italic().bold())
            print(BFMessage.fileError.italic().bold())
            print("\n\n\n")
        } else if list.count >= 2 {
            let fName = String(list[1])
            
            let fType = BFIo.checkFileType(fileName: fName)
            
            do {
                switch fType {
                case .BFSourceCode:
                    let program = try BFIo.readSourceCodeFile(fileName: fName)
                    BFRepl.resetTape()
                    try BFRepl.evalPrintLoop(input: program)
                case .BFBitCode:
                    let bitcodes = try BFIo.readBitcodesFromFile(fileName: fName)
                    let _ = try BFVirtualMachine.runBitcode(code: bitcodes)
                default:
                    throw BFError.EUnknownFileType
                }
            } catch {
                throw error
            }
            
            // It keeps fName for possible reload file operation.
            loadedFile = fName
        }
    }
    
    
    
    
    
    //
    // evalPrintLoop :: String -> Void
    //
    static func evalPrintLoop(input: String) throws -> Void {
        do {
            if try BFCompiler.areBracketsBalanced(sourceCode: input) {
                let bitcodes = BFCompiler.compile(sourceCode: input)
                let _ = try BFInterpreter.runCodeFromREPL(code: bitcodes,
                                                          tape: &tape,
                                                          tapeIndex: &index,
                                                          maxKnownIndex: &maxKnownIndex,
                                                          loopStack: &loopStack,
                                                          debug: debug)
                
                if feedback {
                    BFRepl.printFeedBack()
                }
                
                if continuous == false {
                    BFRepl.resetTape()
                }
            }
        } catch {
            throw error
        }
    }
    
    
    
    
    
    ///
    /// repl :: Void -> BFExitCode
    ///
    
    static func repl() throws -> BFExitCode {
        
        // Greetings
        print("\n\n\n\n\n\n\n")
        print(BFMessage.header.foregroundColor(.yellow2).bold())
        print("\n\n\n\n")
        print(BFMessage.welcome.foregroundColor(.lightCyan1).italic())
        print(BFVersion.replVersion.foregroundColor(.lightCyan1).italic())
        print(BFMessage.help.foregroundColor(.lightCyan1).italic())
        print("\n\n")
        
        
        
        
        
        ///
        /// REPL - Main
        ///
        
        mainLoop: while true {
            do {
                // Read
                let input = BFIo.readLineFromTerminal()
                
                
                
                
                
                // Checking for Repl Options first, then
                // Eval, Print and Loop.
                if input.hasPrefix("load") {
                    try BFRepl.loadFile(input: input)
                }
                
                switch input {
                case BFReplOptions.Exit.description,
                     BFReplOptions.Quit.description:
                    break mainLoop
                case BFReplOptions.Tape.description:
                    BFRepl.printTape()
                case BFReplOptions.Cell.description:
                    BFRepl.printCellStateAtCurrentIndex()
                case BFReplOptions.Index.description:
                    BFRepl.printCurrentIndex()
                case BFReplOptions.Reset.description:
                    BFRepl.resetTape()
                    print(BFMessage.reset.foregroundColor(.orange3).italic())
                case BFReplOptions.Information.description:
                    BFRepl.printInfo()
                case BFReplOptions.Clear.description:
                    print("\u{001B}[2J")
                case BFReplOptions.About.description:
                    print(BFMessage.about.italic())
                case BFReplOptions.Help.description:
                    print(BFMessage.replHelp.italic())
                case BFReplOptions.Feedback.description:
                    if feedback {
                        feedback = false
                        print(BFMessage.feedBackOff.foregroundColor(.orange3).italic())
                    } else {
                        feedback = true
                        print(BFMessage.feedBackOn.foregroundColor(.orange3).italic())
                    }
                case BFReplOptions.DebugMode.description:
                    if debug {
                        debug = false
                        print(BFMessage.debugOff.foregroundColor(.orange3).italic())
                    } else {
                        debug = true
                        print(BFMessage.debugOn.foregroundColor(.orange3).italic())
                    }
                case BFReplOptions.Continuous.description:
                    if continuous {
                        continuous = false
                        print(BFMessage.continuedOff.foregroundColor(.orange3).italic())
                    } else {
                        continuous = true
                        print(BFMessage.continuedOn.foregroundColor(.orange3).italic())
                    }
                case BFReplOptions.ReloadFile.description:
                    try BFRepl.loadFile(input: "load " + loadedFile)
                default:
                    try BFRepl.evalPrintLoop(input: input)
                }
            } catch {
                print("\n\n\n\n       ✖︎   Error:".foregroundColor(.red3).italic().bold())
                print(String(describing: error).italic().bold())
                print("\n\n\n")
            }
        }
        
        
        
        
        
        // Farewells!
        print("\n       ")
        print(BFMessage.leaving.foregroundColor(.lightCyan1).italic())
        print("\n")
        
        
        
        
        
        // It is just for remember the old school!
        return BFExitCode.Success
    }
}





///
/// BFReplOptions
/// ADT - Sum Type
///
/// It has all the BFRepl options.
///

enum BFReplOptions: CustomStringConvertible {
    case Exit
    case Quit
    case Reset
    case Clear
    case Cell
    case Tape
    case Index
    case Information
    case Feedback
    case DebugMode
    case Continuous
    case LoadFile
    case ReloadFile
    case Help
    case About
    case Unknown
    
    var description: String {
        switch self {
        case .Exit:
            return "exit"
        case .Quit:
            return "q"
        case .Reset:
            return "reset"
        case .Clear:
            return "clear"
        case .Cell:
            return "cell"
        case .Tape:
            return "tape"
        case .Index:
            return "index"
        case .Information:
            return "info"
        case .Feedback:
            return "feedback"
        case .DebugMode:
            return "debug"
        case .Continuous:
            return "continuous"
        case .LoadFile:
            return "load"
        case .ReloadFile:
            return "reload"
        case .Help:
            return "help"
        case .About:
            return "about"
        default:
            return "unknown"
        }
    }
}




































