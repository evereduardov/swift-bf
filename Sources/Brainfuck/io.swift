//
//  io.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/6/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// BFFileType
/// ADT - Sum Type
///
/// It is a sum type for describing
/// BF file types and extensions.
///
/// The '.bf' extension is for BF source code files.
/// The '.bf_bitcode' is for BF bitcode files.
///

enum BFFileType: CustomStringConvertible {
    case BFSourceCode
    case BFBitCode
    case BFUnknown
    
    var description: String {
        switch self {
        case .BFSourceCode:
            return ".bf"
        case .BFBitCode:
            return ".bfc"
        default:
            return "unknown"
        }
    }
}





///
/// BFIo
/// Static Class
///
/// It is a static class to deal with
/// IO actions on source code files or repl.
///

class BFIo {
    
    ///
    /// readLineFromTerminal :: String -> String
    ///
    /// It reads characters from the command line.
    /// It strips the new line terminator.
    /// When ^D is pressed it leaves the repl or process.
    ///
    /// - parameter prompt: An optional String to prompt.
    /// - return: A String.
    ///
    
    static func readLineFromTerminal(prompt: String = "\n    ❯   ") -> String {
        print(prompt, separator: "", terminator: "")
        
        let line = readLine(strippingNewline: true)
        
        if let _ = line {
            return line!
        } else {
            // Farewells!
            print("\n       ")
            print(BFMessage.leaving)
            print("\n".reset())
            exit(EXIT_SUCCESS)
        }
    }
    
    
    
    
    
    ///
    /// chopBFExtension :: String -> String
    ///
    /// Chop the bf file extension.
    /// It assumes that checkFileType returned .BFSourceCode
    ///
    
    static func chopBFExtension(fname: String) -> String {
        var index = fname.endIndex
        let limit = BFFileType.BFSourceCode.description.count.advanced(by: 1)
        
        for _ in 0..<limit {
            index = fname.index(before: index)
        }
        
        return String(fname[...index])
    }
    
    
    
    
    
    ///
    /// checkFileType :: String -> BFFileType
    ///
    /// It checks if a given name has a valid bf extension.
    /// -parameter fileName: A given file name.
    /// -return: BFFileType
    ///
    
    static func checkFileType(fileName: String) -> BFFileType {
        if fileName.hasSuffix(BFFileType.BFSourceCode.description) {
            return BFFileType.BFSourceCode
        } else if fileName.hasSuffix(BFFileType.BFBitCode.description) {
            return BFFileType.BFBitCode
        } else {
            return BFFileType.BFUnknown
        }
    }
    
    
    
    
    
    ///
    /// readSourceCodeFile :: String -> String
    ///
    /// It tries to read a BF source code file.
    /// It throws an error when something wrong happens.
    ///
    /// -parameter name: The BF source code file name.
    /// -return: A String with the BF program.
    ///
    
    static func readSourceCodeFile(fileName: String) throws -> String {
        
        // This is for prevent ".bf" inputs
        if fileName.count <= BFFileType.BFSourceCode.description.count {
            throw BFError.EReadingSourceCode
        }
        
        
        let file = FileManager()
        let exist = file.fileExists(atPath: fileName)
        let readable = file.isReadableFile(atPath: fileName)
        
        
        if !exist {
            throw BFError.EFileDoesNotExist
        }
        
        if !readable {
            throw BFError.EFileIsNotReadable
        }
        
        
        do {
            return try String(contentsOfFile: fileName)
        } catch {
            throw error
        }
    }
    
    
    
    
    
    ///
    /// writeBitcodesToFile :: [Bitcode] -> String -> BFExitCode
    ///
    /// -parameter bitcodes: An array of bitcodes to be written to a file.
    /// -parameter outputName: The output name of the bitcode file.
    /// -return: BFExitCode
    ///
    
    static func writeBitcodesToFile(bitcodes: [Bitcode], outputName: String) throws -> BFExitCode {
        
        // The next line assumes chopBFExtension
        let name = outputName + BFFileType.BFBitCode.description
        
        let encoder = JSONEncoder()
        
        do {
            let encodedData = try encoder.encode(bitcodes)
            let stringEncodedData = String.init(bytes: encodedData.base64EncodedData(), encoding: .utf8)
            
            if let _ = stringEncodedData {
                try stringEncodedData!.write(toFile: name, atomically: false, encoding: .utf8)
                return BFExitCode.Success
            } else {
                throw BFError.EWritingBitcodes
            }
        } catch {
            throw error
        }
    }
    
    
    
    
    
    ///
    /// readBitcodesFromFile :: String -> [Bitcode]
    ///
    /// -parameter fileName: The bitcode file name.
    /// -return: An array of bitcodes.
    ///
    
    static func readBitcodesFromFile(fileName: String) throws -> [Bitcode] {
        
        // This is for prevent ".bfc" inputs
        if fileName.count <= BFFileType.BFBitCode.description.count {
            throw BFError.EUnknownFileFormat
        }
        
        let file = FileManager()
        let exist = file.fileExists(atPath: fileName)
        let readable = file.isReadableFile(atPath: fileName)
        
        if !exist {
            throw BFError.EFileDoesNotExist
        }
        
        if !readable {
            throw BFError.EFileIsNotReadable
        }
        
        let decoder = JSONDecoder()
        var bitcodes = [Bitcode]()
        
        do {
            let content = try String(contentsOfFile: fileName)
            if let data = Data(base64Encoded: content) {
                bitcodes = try decoder.decode([Bitcode].self, from: data)
                return bitcodes
            } else {
                throw BFError.EReadingBitcodes
            }
        } catch {
            throw error
        }
    }
}

















