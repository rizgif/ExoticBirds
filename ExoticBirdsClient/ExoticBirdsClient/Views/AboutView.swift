//
//  AboutView.swift
//  ExoticBirdsClient
//
//  Created by Davin Leong on 2024-11-19.
//

import Foundation
import SwiftUICore
import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            // light pastel blue
            Color(red: 0.90, green: 0.96, blue: 1)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 10) {
                Text("Authors")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                    .padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Riz Nur Saidy, ID: A00874466")
                    Text("Davin Leong, ID: A01344186")
                }
                .font(.body)
                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                .padding()
                .background(Color(red: 0.8, green: 0.9, blue: 1)) // Soft blue background for the text container
                .cornerRadius(12)
                .shadow(radius: 5)
            }
            .padding()
        }
        
    }
}

#Preview {
    AboutView()
}
