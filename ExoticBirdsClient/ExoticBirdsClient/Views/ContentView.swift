//
//  ContentView.swift
//  ExoticBirdsClient
//
//  Created by Davin Leong on 2024-11-19.
//

import Foundation
import SwiftUICore
import SwiftUI

struct ContentView: View {
    var body: some View {
    Text("Exotic Birds")
        .font(.largeTitle)
        .padding()
        
    Divider()
        
    TabView {
        BirdReadView()
            .tabItem {
                Label("Read", systemImage: "book")
            }
        BirdCreateView()
            .tabItem {
                Label("Create", systemImage: "plus")
            }
        BirdUpdateView()
            .tabItem {
                Label("Update", systemImage: "square.and.pencil")
            }
        BirdDeleteView()
            .tabItem {
                Label("Delete", systemImage: "trash")
            }
        AboutView()
            .tabItem {
                Label("About", systemImage: "info.circle.fill")
            }
    }
}
}

#Preview {
    ContentView()
}
