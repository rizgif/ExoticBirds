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
        VStack(spacing: 0) {
            Text("Exotic Birds 🪿")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.9, green: 0.8, blue: 1.0), // Light purple
                            Color(red: 0.7, green: 0.5, blue: 1.0)  // Deeper purple
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            
            Divider()
            
            // Main content with TabView
            TabView {
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle.fill")
                    }
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
                
            }
            .background(Color(red: 0.94, green: 0.85, blue: 1.0)) 
        }
        .background(Color(red: 0.94, green: 0.85, blue: 1.0))
        
    }
}

#Preview {
    ContentView()
}

