//
//  ContentView.swift
//  WeSplit
//
//  Created by Anastasia Kotova on 10.12.22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 10
    @FocusState private var amountIsFocused: Bool
    
    private let tipPercentages = [0, 5, 10, 15, 20, 25]
    private let currencyFotmatter: FloatingPointFormatStyle<Double>.Currency = .currency(code:Locale.current.identifier)
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipTotal = checkAmount * (tipSelection / 100)
        let grandTotal = checkAmount + tipTotal
        return grandTotal / peopleCount
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format:
                            .currency(code:Locale.current.identifier))
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }header: {
                    Text("Enter your data:")
                }
                
                Section {
                    Picker("% tip", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text("Amount per person:").bold()
                    Text(cutDecimal(totalPerPerson), format: currencyFotmatter)
                    Text("Total amount:").bold()
                    Text(cutDecimal(totalPerPerson * Double(numberOfPeople + 2)), format: currencyFotmatter)
                    Text("Amount of tips:").bold()
                    Text(cutDecimal(checkAmount * (Double(tipPercentage) / 100)), format: currencyFotmatter)
                }
            }
            .navigationTitle("We split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

private func cutDecimal(_ number: Double) -> Double {
    return Double(round(100 * number) / 100)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
