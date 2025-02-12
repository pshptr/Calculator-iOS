import SwiftUI

struct ContentView: View {
    @State private var input: String = ""
    @State private var storedValue: Double? = nil
    @State private var currentOperation: String? = nil
    @State private var result: String = ""
    
    let buttons = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "*"],
        ["1", "2", "3", "-"],
        ["0", "C", "=", "+"]
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(input.isEmpty ? "0" : input)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
            Text(result)
                .font(.title)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
            ForEach(buttons.indices, id: \.self) { row in
                HStack {
                    ForEach(buttons[row], id: \.self) { button in
                        Button(action: {
                            buttonTapped(button)
                        }) {
                            Text(button)
                                .font(.title)
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    func buttonTapped(_ button: String) {
        if let _ = Double(button) {
            input += button
        } else if button == "C" {
            input = ""
            storedValue = nil
            currentOperation = nil
            result = ""
        } else if button == "=" {
            calculateResult()
        } else {
            if let value = Double(input) {
                storedValue = value
                currentOperation = button
                input = ""
            }
        }
    }
    
    func calculateResult() {
        if let value = Double(input), let stored = storedValue, let operation = currentOperation {
            switch operation {
            case "+": result = String(stored + value)
            case "-": result = String(stored - value)
            case "*": result = String(stored * value)
            case "/": result = value != 0 ? String(stored / value) : "Error"
            default: break
            }
            storedValue = nil
            currentOperation = nil
        }
    }
}

struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
