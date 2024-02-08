//
//  ContentView.swift
//  iExpense
//
//  Created by New on 1/12/23.
//
import SwiftData
import SwiftUI
/*
class User: ObservableObject, Codable{
    var firstName = "Jairo"
    var lastName = "Laurente"
}
struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    let name: String
    var body: some View{
        Button("dismiss"){
            dismiss()
        }
        
    }
}
*/

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
   /*
    @State private var user = User()
    @State private var showingSheet = false
    
    //Crear vistas con listas donde se eliminan y agregan
    
    @State private var number = [Int]()
    @AppStorage("currentNumber") private var currentNumber = 1
    
    func removeRows(at offsets: IndexSet){
        number.remove(atOffsets: offsets)
    }*/
    @Environment(\.modelContext) var modelContext
    @StateObject private var expenses = Expenses()
    
    @State private var showingExpense = false
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
   
    var body: some View {
       /* NavigationStack {
            VStack{
                Text("Your name is \(user.firstName) \(user.lastName)")
                TextField("First name", text: $user.firstName)
                TextField("Last name", text: $user.lastName)
                Button("Show Alert"){
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet){
                    SecondView(name: "Jairo")
                }
                VStack{
                    //       Cualquiera de los dos
                    List{
                        ForEach(number, id: \.self){
                            Text("Row \($0)")
                        }
                        .onDelete(perform: removeRows)
                    }
                    Button("Add number: \(currentNumber)"){
                        number.append(currentNumber)
                        currentNumber += 1
                       // UserDefaults.standard.setValue(currentNumber, forKey: "Tap")
                    }
                    
                }
                .padding()
                        
            }
            .toolbar{
                EditButton()
            }
        }
        */
        /*
        Button("Save User"){
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(user){
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
        */
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
