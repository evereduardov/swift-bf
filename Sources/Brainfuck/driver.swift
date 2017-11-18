//
//  driver.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/6/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// BFDriver
/// Static Class
///
/// The entry point of the BF compiler and BF interpreter.
/// It deals with all the interpreter cmd options.
///

class BFDriver {
    
    
    
    
    
    ///
    /// interpret :: String -> ()
    /// private helping function
    ///
    
    private static func interpret(fName: String) throws -> Void {
        do {
            let program = try BFIo.readSourceCodeFile(fileName: fName)
            let balanced = try BFCompiler.areBracketsBalanced(sourceCode: program)
            
            if balanced {
                let bitcodes = BFCompiler.compile(sourceCode: program)
                let _ = try BFVirtualMachine.runBitcode(code: bitcodes)
            }
        } catch {
            throw error
        }
    }
    
    
    
    
    
    ///
    /// compile :: String -> ()
    /// private helping function.
    ///
    
    private static func compile(fName: String) throws -> Void {
        do {
            let program = try BFIo.readSourceCodeFile(fileName: fName)
            let balanced = try BFCompiler.areBracketsBalanced(sourceCode: program)
            
            if balanced {
                let bitcodes = BFCompiler.compile(sourceCode: program)
                let name = BFIo.chopBFExtension(fname: fName)
                let _ = try BFIo.writeBitcodesToFile(bitcodes: bitcodes, outputName: name)
            }
        } catch {
            throw error
        }
    }
    
    
    
    
    
    ///
    /// Entry point of the BF interpreter.
    ///
    
    static func BFMain() -> Void {
        do {
            if CommandLine.argc == 1 {
                let _ = try BFRepl.repl()
            } else if CommandLine.argc >= 2 {
                let args = CommandLine.arguments
                var index = args.startIndex.advanced(by: 1)
                
                
                while index < args.endIndex {
                    switch args[index] {
                    case BFCommandLineOptions.VersionLarge.description,
                         BFCommandLineOptions.VersionShort.description:
                        print(BFVersion.version.italic())
                    case BFCommandLineOptions.HelpLarge.description,
                         BFCommandLineOptions.HelpShort.description:
                        print(BFMessage.interpreterUsageHelp.italic())
                    case BFCommandLineOptions.AboutLarge.description,
                         BFCommandLineOptions.AboutShort.description:
                        print(BFMessage.about.italic())
                    case BFCommandLineOptions.CompileLarge.description,
                         BFCommandLineOptions.CompileShort.description:
                        index = index.advanced(by: 1)
                        if index == args.endIndex {
                            print("\n\n\n\n       ✖︎   Error:".foregroundColor(.red3).italic().bold())
                            print("       No files to compile.".italic().bold())
                            print("\n\n\n")
                            exit(EXIT_SUCCESS)
                        } else {
                            compileLoop: while index < args.endIndex {
                                if args[index].hasSuffix(BFFileType.BFSourceCode.description) {
                                    try BFDriver.compile(fName: args[index])
                                    index = index.advanced(by: 1)
                                } else {
                                    print("\n\n\n\n       ✖︎   Error:".foregroundColor(.red3).italic().bold())
                                    print("       No files to compile.".italic().bold())
                                    print("\n\n\n")
                                    exit(EXIT_SUCCESS)
                                }
                            }
                        }
                    case BFCommandLineOptions.DebugLarge.description,
                         BFCommandLineOptions.DebugShort.description:
                        index = index.advanced(by: 1)
                        if index == args.endIndex {
                            print("\n\n\n\n       ✖︎   Error:".foregroundColor(.red3).italic().bold())
                            print("       No files to debug.".italic().bold())
                            print("\n\n\n")
                            exit(EXIT_SUCCESS)
                        } else {
                            debugLoop: while index < args.endIndex {
                                let fType = BFIo.checkFileType(fileName: args[index])
                                switch fType {
                                case .BFSourceCode:
                                    let program = try BFIo.readSourceCodeFile(fileName: args[index])
                                    let balanced = try BFCompiler.areBracketsBalanced(sourceCode: program)
                                    if balanced {
                                        BFRepl.debug = true
                                        try BFRepl.evalPrintLoop(input: program)
                                    }
                                case .BFBitCode:
                                    let bitcodes = try BFIo.readBitcodesFromFile(fileName: args[index])
                                    let program = BFCompiler.decompile(bitcodes: bitcodes)
                                    BFRepl.debug = true
                                    try BFRepl.evalPrintLoop(input: program)
                                default:
                                    print("\n\n\n\n       ✖︎   Error:".foregroundColor(.red3).italic().bold())
                                    print("       Unknown file type or command line option.".italic().bold())
                                    print("\n\n\n")
                                    exit(EXIT_SUCCESS)
                                }
                                index = index.advanced(by: 1)
                            }
                        }
                    default:
                        interpreterLoop: while index < args.endIndex {
                            let fType = BFIo.checkFileType(fileName: args[index])
                            switch fType {
                            case .BFSourceCode:
                                try BFDriver.interpret(fName: args[index])
                            case .BFBitCode:
                                let program = try BFIo.readBitcodesFromFile(fileName: args[index])
                                let _ = try BFVirtualMachine.runBitcode(code: program)
                            default:
                                print("\n\n\n\n       ✖︎   Error:".foregroundColor(.red3).italic().bold())
                                print("       Unknown file type or command line option.".italic().bold())
                                print("\n\n\n")
                                exit(EXIT_SUCCESS)
                            }
                            index = index.advanced(by: 1)
                        }
                    }
                    index = index.advanced(by: 1)
                }
            }
        } catch {
            // Every possible non REPL error ends here!
            print("\n\n\n\n       ✖︎   Error:".foregroundColor(.red3).italic().bold())
            print(String(describing: error).italic().bold())
            print("\n\n\n")
        }
    }
}





///
/// BFDriverOptions
/// ADT - Sum Type
///
/// It has all the driver's options.
///

enum BFCommandLineOptions: CustomStringConvertible {
    case VersionLarge
    case VersionShort
    case HelpLarge
    case HelpShort
    case AboutLarge
    case AboutShort
    case CompileLarge
    case CompileShort
    case DebugLarge
    case DebugShort
    case Default
    
    var description: String {
        switch self {
        case .VersionLarge:
            return "--version"
        case .VersionShort:
            return "-v"
        case .HelpLarge:
            return "--help"
        case .HelpShort:
            return "-h"
        case .AboutLarge:
            return "--about"
        case .AboutShort:
            return "-a"
        case .CompileLarge:
            return "--compile"
        case .CompileShort:
            return "-c"
        case .DebugLarge:
            return "--debug"
        case .DebugShort:
            return "-d"
        default:
            return "Default"
        }
    }
}




















