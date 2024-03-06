//
//  ContentView.swift
//  iExpense
//
//  Created by New on 1/12/23.
//
import SwiftData
import SwiftUI


struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
class Expenses: ObservableObject{
    @Published var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){ //pasar a JSON
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){ //de JSON A SWIFT
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){ //desarchiva la data o el objeto de una matriz de ExpenseItem
                items = decodedItems
                return
            }
        }
        items = []
    }
}
@available(iOS 17.0, *)
struct ContentView: View {
   
    @Environment(\.modelContext) var modelContext
    @StateObject private var expenses = Expenses()
    
    @State private var showingExpense = false
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
   
    var body: some View {
       
        NavigationStack{
            List{
                ForEach(expenses.items){ item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text((item.amount),format: .currency(code: Locale.current.currency?.identifier ?? "USD")) // el format: currency.locale hace que se elija la moneda de preferencia
                            .foregroundStyle(item.amount <= 100 ? .green : .red)
                    }
                    
                   
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar{
                //Button("Add Expense") {
                    NavigationLink("Add expense"){
                        AddView(expenses: expenses)
                    }
                    //showingExpense = true
                    
                //}
            }
//            .sheet(isPresented: $showingExpense) {
//                AddView(expenses: expenses)
//            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 17.0, *) {
            ContentView()
        } else {
            // Fallback on earlier versions
        }
    }
}
