//
//  main.swift
//  BBfck
//
//  Created by Tiago Bastos on 7/8/14.
//  Copyright (c) 2014 Tiago Bastos. All rights reserved.
//

import Foundation

let dataStackSize = 300

struct Program {
    let instructions: [Instructions]
    var data: [Int]
    var ip: Int
    var dp: Int
}

enum Instructions : Character {
    case Increase = "+"
    case Decrease = "-"
    case StartLoop = "["
    case EndLoop = "]"
    case ReadChar = ","
    case PrintChar = "."
    case IncreasePointer = ">"
    case DecreasePointer = "<"
}

func readCode(program: String) -> [Instructions] {
    var stack = [Instructions]()

    for char in program {
        if char == "!" {
            return stack
        } else {
            stack.append(Instructions.fromRaw(char)!)
        }
    }
    
    return stack
}

func executeCode(code: String) {
    var data = Array(count: dataStackSize, repeatedValue: 0)
    let instructions = readCode(code)
    var program = Program(instructions: instructions, data: data, ip: 0, dp: 0)
    
    while program.ip < program.instructions.count {
        let instruction = program.instructions[program.ip]
        switch (instruction) {
            case .IncreasePointer:
                program.dp += 1
            case .DecreasePointer:
                program.dp -= 1
            case .Increase:
                program.data[program.dp] += 1
            case .Decrease:
                program.data[program.dp] -= 1
            case .PrintChar:
                print(Character(UnicodeScalar(program.data[program.dp])))
            case .StartLoop:
                var depth = 0
                if program.data[program.dp] == 0 {
                    program.ip += 1
                    while depth > 0 || program.instructions[program.ip] != .EndLoop {
                        if program.instructions[program.ip] == .StartLoop {
                            depth += 1
                        } else if program.instructions[program.ip] == .EndLoop {
                            depth -= 1
                        }
                        program.ip += 1
                    }
                }
            case .EndLoop:
                var depth = 0
                program.ip -= 1
                while depth > 0 || program.instructions[program.ip] != .StartLoop {
                    if program.instructions[program.ip] == .EndLoop {
                        depth += 1
                    } else if program.instructions[program.ip] == .StartLoop {
                        depth -= 1
                    }
                    program.ip -= 1
                }
                program.ip -= 1
            default:
                println("ERROR \(program.instructions[program.ip].toRaw()) is not a implemented instruction")
                exit(EXIT_FAILURE)
        }
        
        program.ip += 1
    }
}

executeCode("++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.")