//
//  ContentView.swift
//  Calculator-iOS
//
//  Created by Pe Tia on 12.02.25.
//

import SwiftUI

struct ContentView: View {
    @State private var input: String = ""
    @State private var result: String = ""
    @State private var isCursorVisible = false

    let buttons: [[String]] = [
        ["C", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(spacing: 2) {
                        Text(input)
                            .foregroundColor(.white)
                            .font(.system(size: 56))
                        
                        if !input.isEmpty {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 2, height: 40)
                                .opacity(isCursorVisible ? 1 : 0)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true),
                                    value: isCursorVisible
                                )
                                .onAppear { self.isCursorVisible = true }
                                .onDisappear { self.isCursorVisible = false }
                        }
                    }
                    .padding(.trailing, 10)
                    
                    Text(result)
                        .foregroundColor(.gray)
                        .font(.system(size: 64))
                        .padding(.trailing, 10)
                }
            }
            .padding()
            
            ForEach(buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { button in
                        Button(action: { self.buttonTapped(button) }) {
                            Text(button)
                                .font(.largeTitle)
                                .frame(width: buttonWidth(button), height: 80)
                                .background(buttonColor(button))
                                .foregroundColor(textColor(button))
                                .cornerRadius(20)
                        }
                    }
                }
            }
        }
        .background(Color(white: 0.1).edgesIgnoringSafeArea(.all))
    }

    private func restartCursorAnimation() {
        isCursorVisible = false
        DispatchQueue.main.async {
            withAnimation {
                isCursorVisible = true
            }
        }
    }
    
    private func buttonTapped(_ button: String) {
        
        switch button {
        case "C":
            input = ""
            result = ""
            isCursorVisible = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isCursorVisible = true
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
    
    private func buttonColor(_ button: String) -> Color {
        if ["+", "-", "×", "÷", "%"].contains(button) {
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        } else if button == "C" {
            return Color.red.opacity(0.85)
        } else if button == "=" {
            return Color.green
        } else {
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        }
    }
    
    private func textColor(_ button: String) -> Color {
        if ["+", "-", "×", "÷", "%"].contains(button) {
            return Color.green
        } else {
            if ["C"].contains(button) {
                return Color(red: 0.2, green: 0.2, blue: 0.2)
            }
            if ["="].contains(button) {
                return Color(red: 0.2, green: 0.2, blue: 0.2)
            }
            return Color.white
        }
    }
    
    private func buttonWidth(_ button: String) -> CGFloat {
        if button == "0" {
            return 90
        } else if button == "=" {
            return 180
        } else {
            return 90
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
