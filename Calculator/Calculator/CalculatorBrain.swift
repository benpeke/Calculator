//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Benjamin Schwartz on 2/5/15.
//  Copyright (c) 2015 Benjamin Schwartz. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op : Printable {
        case Operand(Double)
        case Variable(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case Operand(let operation):
                    return "\(operation)"
                case .Variable(let variable, _):
                    return "\(variable)"
                case UnaryOperation(let operation, _):
                    return "\(operation)"
                case BinaryOperation(let operation, _):
                    return "\(operation)"
                }
            }
        }
    }

    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("*", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-"){ $1 - $0 })
        learnOp(Op.BinaryOperation("/"){ $1 / $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.Variable("π", M_PI))
        
    }

    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(_, let variable):
                remainingOps.append(Op.Operand(variable))
                return evaluate(remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEval = evaluate(remainingOps)
                if let operand = operandEval.result {
                    return (operation(operand), operandEval.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandEval = evaluate(remainingOps)
                if let operand1 = operandEval.result {
                    let operandEval2 = evaluate(operandEval.remainingOps)
                    if let operand2 = operandEval2.result {
                        return (operation(operand1, operand2), operandEval2.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }

    func performOperation(symbol:String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }

    func clear() {
        opStack.removeAll(keepCapacity: false)
    }
}
