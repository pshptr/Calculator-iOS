//import SwiftUI
//
//struct ContentView: View {
//    @State private var input: String = ""
//    @State private var storedValue: Double? = nil
//    @State private var currentOperation: String? = nil
//    @State private var result: String = ""
//    
//    let buttons = [
//        ["C", "+/-", "%", "/"],
//        ["7", "8", "9", "×"],
//        ["4", "5", "6", "-"],
//        ["1", "2", "3", "+"],
//        ["0", ".", "="]
//    ]
//    
//    var body: some View {
//        ZStack {
//            Color(hex: "#151515").edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 16) {
//                Spacer()
//                
//                // Дисплей
//                VStack(alignment: .trailing, spacing: 8) {
//                    Text(result)
//                        .font(.system(size: 32, weight: .light))
//                        .foregroundColor(.gray)
//                    
//                    Text(input.isEmpty ? "0" : input)
//                        .font(.system(size: 64, weight: .light))
//                        .foregroundColor(.white)
//                }
//                .padding(.horizontal, 24)
//                
//                // Кнопки
//                ForEach(buttons.indices, id: \.self) { row in
//                    HStack(spacing: 16) {
//                        ForEach(buttons[row], id: \.self) { button in
//                            Button(action: { buttonTapped(button) }) {
//                                buttonView(for: button)
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal, 16)
//                .padding(.bottom, 16)
//            }
//            
//            // Декоративные элементы
//            statusBar
//            decorativeElements
//        }
//    }
//    
//    @ViewBuilder
//    private func buttonView(for button: String) -> some View {
//        let isZero = button == "0"
//        let width: CGFloat = isZero ? 160 : 73
//        let backgroundColor: Color = {
//            switch button {
//            case "C": return Color(hex: "#FF5959")
//            case "=": return Color(hex: "#66FF7F")
//            case "+", "-", "×", "/": return Color(hex: "#343434")
//            default: return Color(hex: "#343434")
//            }
//        }()
//        
//        Text(button)
//            .font(.system(size: 32, weight: .medium))
//            .foregroundColor(button == "×" ? .white : .white)
//            .frame(width: width, height: 75)
//            .background(backgroundColor)
//            .cornerRadius(9)
//    }
//    
//    // Декоративные элементы статус-бара
//    private var statusBar: some View {
//        VStack {
//            HStack {
//                Text("9:41")
//                    .foregroundColor(.white)
//                Spacer()
//                HStack(spacing: 4) {
//                    Image(systemName: "cellularbars")
//                    Image(systemName: "wifi")
//                    Image(systemName: "battery.75")
//                }
//                .foregroundColor(.white)
//            }
//            .padding(.horizontal, 24)
//            .padding(.top, 12)
//            
//            Spacer()
//        }
//    }
//    
//    // Зеленые декоративные элементы
//    private var decorativeElements: some View {
//        ZStack {
//            // Зеленая линия под дисплеем
//            Rectangle()
//                .fill(Color(hex: "#4E4D4D"))
//                .frame(height: 1)
//                .padding(.horizontal, 19)
//                .offset(y: -220)
//            
//            // Другие элементы по аналогии с SVG...
//            
//        }
//    }
//    
//    func buttonTapped(_ button: String) {
//            if let _ = Double(button) {
//                input += button
//            } else if button == "C" {
//                input = ""
//                storedValue = nil
//                currentOperation = nil
//                result = ""
//            } else if button == "=" {
//                calculateResult()
//            } else {
//                if let value = Double(input) {
//                    storedValue = value
//                    currentOperation = button
//                    input = ""
//                }
//            }
//        }
//    
//    func calculateResult() {
//            if let value = Double(input), let stored = storedValue, let operation = currentOperation {
//                switch operation {
//                case "+": result = String(stored + value)
//                case "-": result = String(stored - value)
//                case "*": result = String(stored * value)
//                case "/": result = value != 0 ? String(stored / value) : "Error"
//                default: break
//                }
//                storedValue = nil
//                currentOperation = nil
//            }
//        }
//    }
//
//// Расширение для работы с HEX-цветами
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default: (a, r, g, b) = (1, 1, 1, 0)
//        }
//        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
//    }
//}
//
//struct CalculatorApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}


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
