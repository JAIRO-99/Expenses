//
//  iExpenseApp.swift
//  iExpense
//
//  Created by New on 1/12/23.
//
import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                ContentView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
