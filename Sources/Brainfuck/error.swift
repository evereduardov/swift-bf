//
//  error.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/6/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// BFError
/// ADT - Sum Type
///
/// It describes some possible errors
/// when executing some BF interpreter function.
///

enum BFError: Error, CustomStringConvertible {
    case EReadingSourceCode
    case EIndexOutOfRange
    case EUnbalancedBrackets
    case EWritingBitcodes
    case EReadingBitcodes
    case EUnicodeScalarOutOfRange
    case EUnicodeNilValue
    case EUnknownFileType
    case ERunTimeUnknownBitcode
    case ERunTimeUnknownBitcodeFileFormat
    case EUnknownFileFormat
    case ECommandLineUnknownOption
    case EFileDoesNotExist
    case EFileIsNotReadable
    case EUnexpectedFailure
    
    
    
    
    
    ///
    /// description :: BFError -> String
    ///
    
    var description: String {
        switch self {
        case .EReadingSourceCode:
            return "       Cannot read the source code file."
        case .EIndexOutOfRange:
            let first = "       Attempt to go before the first cell on the tape.\n"
            let second = "       The tape does not have negative indices."
            return first + second
        case .EUnbalancedBrackets:
            return "       The code read has unbalanced square brackets."
        case .EWritingBitcodes:
            return "       Cannot write the bitcode file."
        case .EReadingBitcodes:
            return "       Cannot read bitcodes from a file."
        case .EUnicodeScalarOutOfRange:
            return "       Unicode Scalars cannot be built from negative integers."
        case .EUnicodeNilValue:
            return "       Unicode Scalar not defined yet."
        case .EUnknownFileType:
            return "       Unknown file type."
        case .ERunTimeUnknownBitcode:
            return "       Found unknown bitcode at run time.\n       Maybe the BF bitcode file may be corrupted."
        case .ERunTimeUnknownBitcodeFileFormat:
            return "       Not valid BF bitcode file."
        case .EUnknownFileFormat:
            return "       Unknown file format."
        case .ECommandLineUnknownOption:
            return "       Unknown command line option."
        case .EFileDoesNotExist:
            return "       No such file or directory."
        case .EFileIsNotReadable:
            return "       File not readable."
        default:
            return "       Yikes! :: Some unexpected failure has happened to the BF interpreter. 🤢"
        }
    }
}















