//
//  messages.swift
//  bf
//
//  Created by Ever Eduardo Velazco Romero on 11/5/17.
//  Copyright © 2017 ANSoft. All rights reserved.
//

import Foundation





///
/// BFMessage
/// Static Class
///
/// It has the most of the interpreter/repl messages.
///

class BFMessage {
    static let header =
    """
          _____ _____           _____ _____ _____ __
         | __  |   __|   ___   | __  |   __|  _  |  |
         | __ -|   __|  |___|  |    -|   __|   __|  |__
         |_____|__|            |__|__|_____|__|  |_____|
    """
    
    static let welcome      = "     Welcome to the BF - REPL!"
    static let help         = "     Type help for assistance."
    static let leaving      = "     Leaving BF."
    static let fileError    = "       No file name given to the option 'load'."
    static let feedBackOn   = "        REPL Feedback mode is on."
    static let feedBackOff  = "        REPL Feedback mode is off."
    static let debugOn      = "        REPL Debug mode is on."
    static let debugOff     = "        REPL Debug mode is off."
    static let continuedOn  = "        REPL Continuous mode is on."
    static let continuedOff = "        REPL Continuous mode is off."
    static let testModeOn   = "        REPL test mode is on."
    static let testModeOff  = "        REPL test mode is off."
    static let reset        = "        Everthing was reset."
    static let replHelp     =
    """
            \n\n
            🔆   BF - REPL

            Options:
            
            cell            Show the current cell ant index position.
            index           Show the current tape index position.
            tape            Show the current tape state up to maxKnownIndex index.
            info            Show feedback plus other REPL states.
            feedback        Turn on/off the current REPL state after each line read.
            debug           Turn on/off the debug repl mode. A step by step computation.
            continuous      Turn on/off the continuous repl mode.
            reset           Reset everything.
            clear           Clear the screen.
            help            Show this message.
            exit            Quit the BF REPL. You can use q as well.
            about           Show some informtation about BF.
            load            load <input>.bf(c) Load and run the <input>.bf(c) file.
            reload          Reload the last loaded file.
            
            The REPL continuous mode is on by default.
            
    """
    
    static let interpreterUsageHelp =
    """
           \n\n
           🔆   BF - Help
           USAGE:       brainfuck [option] <inputs>


           Options:
           -a           Show info about bf.
           -v           Show version information.
           -h           Diaplay available options.
           -c           Compile a bf source file.
           -d           Run the interpreter in debug mode.
           --about      Show info about bf.
           --version    Show version information.
           --help       Display available options.
           --compile    Compile a bf source file.
           --debug      Run the interpreter in debug mode.


           Inputs:
           [...].bf     Source code file.
           [...].bfc    Object code file.


           Extensions:
           .bf          Source code file extension.
           .bfc         Object code file extension.\n\n\n
    """
    
    static let about =
    """
           \n\n\n\n\n\n\n
           🔆   Brainfuck

           "[It] is an esoteric programming language created in 1993 by Urban Müller,
           and notable for its extreme minimalism."

           "The language consists of only eight simple commands and an instruction pointer."

           "It is not intended for practical use,
           but to challenge and amuse programmers."

           Source: https://en.wikipedia.org/wiki/Brainfuck

           \n\n\n
    """
}





///
/// BFVersion
/// Static Class
///
/// It has all about the BF driver version info.
///

class BFVersion {
    static let major = "1"
    static let minor = "0"
    static let patch = "0"
    static let version = "\n\n       🔆   BF Interpreter. Version \(major).\(minor).\(patch)\n\n"
    static let replVersion = "     BF Interpreter. Version \(major).\(minor).\(patch)"
}
























