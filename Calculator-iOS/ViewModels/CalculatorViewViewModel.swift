//
//  CalculatorViewViewModel.swift
//  Calculator-iOS
//
//  Created by Pe Tia on 18.02.25.
//

import Foundation
import SwiftUICore

final class CalculatorViewViewModel: ObservableObject {
    
    @Published var input: String = ""
    @Published var result: String = ""
    @Published var isCursorVisible = false
    
    func buttonTapped(_ button: String) {
        switch button {
        case "C":
            input = ""
            result = ""
            isCursorVisible = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isCursorVisible = true
            }
        case "=":
            calculateResult()
        case "+/-":
            if let value = Double(input) {
                input = "\(-value)"
                restartCursorAnimation()
            }
        case "%":
            if input.isEmpty { return }
            input.append("%")
            restartCursorAnimation()
        default:
            input.append(button)
            restartCursorAnimation()
        }
    }
    
    private func calculateResult() {
        var processedInput = input
        
        let operators = CharacterSet(charactersIn: "+-×÷")
        let components = processedInput.components(separatedBy: operators)
        _ = processedInput.indices.filter {
            if let scalar = String(processedInput[$0]).unicodeScalars.first {
                return operators.contains(scalar)
            }
            return false
        }
        
        for (index, component) in components.enumerated().reversed() {
            if component.hasSuffix("%") {
                let numberStr = String(component.dropLast())
                if let number = Double(numberStr) {
                    let percentage = number / 100
                    
                    if index == 0 {
                        processedInput = processedInput.replacingOccurrences(of: component, with: String(percentage))
                    } else {
                        let previousComponent = components[index - 1]
                        if let baseNumber = Double(previousComponent) {
                            let result = baseNumber * percentage
                            processedInput = processedInput.replacingOccurrences(of: component, with: String(result))
                        }
                    }
                }
            }
        }
        
        let expression = NSExpression(format: processedInput.replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/"))
        if let resultValue = expression.expressionValue(with: nil, context: nil) as? Double {
            result = "\(resultValue)"
        }
    }
    
    private func restartCursorAnimation() {
        isCursorVisible = false
        DispatchQueue.main.async { [self] in
            withAnimation {
                isCursorVisible = true
            }
        }
    }
}
