//
//  CalculatorView.swift
//  Calculator-iOS
//
//  Created by Pe Tia on 18.02.25.
//

import SwiftUI

struct CalculatorView: View {
    
    @StateObject private var viewModel = CalculatorViewViewModel()
   

    let buttons: [[String]] = [
        ["C", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    private func buttonWidth(_ button: String) -> CGFloat {
        return button == "=" ? 180 : 90
    }

    private func buttonColor(_ button: String) -> Color {
        switch button {
        case "+/-", "%", "÷", "×", "-", "+":
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        case "C":
            return Color.red
        case "=":
            return Color.green
        default:
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        }
    }

    private func textColor(_ button: String) -> Color {
        switch button {
        case "%", "÷", "×", "-", "+":
            return Color.green
        case "+/-":
            return Color.white
        case "C":
            return Color.black
        case "=":
            return Color.black
        default:
            return Color.white
        }
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(spacing: 2) {
                        Text(viewModel.input)
                            .foregroundColor(.white)
                            .font(.system(size: 56))
                        
                        if !viewModel.input.isEmpty {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 2, height: 40)
                                .opacity(viewModel.isCursorVisible ? 1 : 0)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true),
                                    value: viewModel.isCursorVisible
                                )
                                .onAppear { viewModel.isCursorVisible = true }
                                .onDisappear { viewModel.isCursorVisible = false }
                        }
                    }
                    .padding(.trailing, 10)
                    
                    Text(viewModel.result)
                        .foregroundColor(.gray)
                        .font(.system(size: 64))
                        .padding(.trailing, 10)
                }
            }
            .padding()
            
            ForEach(buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { button in
                        Button(action: { viewModel.buttonTapped(button) }) {
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
   
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
