//
//  AddView.swift
//  iExpense
//
//  Created by New on 2/12/23.
//

import SwiftUI

struct AddView: View {
    
  @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expenses: Expenses
    
    let types = ["Business","Personal"]
    
    var body: some View {
        NavigationStack{
            Form {
                TextField("Name",text: $name)
                Picker("Type", selection: $type){
                    ForEach(types,id: \.self){
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar{
                Button("Save"){
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
