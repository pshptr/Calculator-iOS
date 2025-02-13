import SwiftUI

struct ContentView: View {
    @State private var input: String = ""
    @State private var result: String = ""
    
    let buttons: [[String]] = [
        ["C", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "=", ""]
    ]
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(input)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding(.trailing, 10)
                    Text(result)
                        .foregroundColor(.gray)
                        .font(.title)
                        .padding(.trailing, 10)
                }
            }
            .padding()
            
            ForEach(buttons, id: \..self) { row in
                HStack {
                    ForEach(row, id: \..self) { button in
                        Button(action: {
                            self.buttonTapped(button)
                        }) {
                            Text(button)
                                .font(.largeTitle)
                                .frame(width: self.buttonWidth(button), height: 80)
                                .background(self.buttonColor(button))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    private func buttonTapped(_ button: String) {
        switch button {
        case "C":
            input = ""
            result = ""
        case "=":
            calculateResult()
        case "+/-":
            if let value = Double(input) {
                input = "\(-value)"
            }
        case "%":
            if let value = Double(input) {
                input = "\(value / 100)"
            }
        default:
            input.append(button)
        }
    }
    
    private func calculateResult() {
        let expression = NSExpression(format: input.replacingOccurrences(of: "×", with: "*"))
        if let resultValue = expression.expressionValue(with: nil, context: nil) as? Double {
            result = "\(resultValue)"
        }
    }
    
    private func buttonColor(_ button: String) -> Color {
        if ["+", "-", "×", "÷", "%"].contains(button) {
            return Color.green
        } else if button == "C" {
            return Color.red
        } else if button == "=" {
            return Color.green.opacity(0.7)
        } else {
            return Color.gray
        }
    }
    
    private func buttonWidth(_ button: String) -> CGFloat {
        return button == "0" ? 160 : 80
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

