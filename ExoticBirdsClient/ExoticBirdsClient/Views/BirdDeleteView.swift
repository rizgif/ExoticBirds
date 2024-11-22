//
//  BirdDeleteView.swift
//  ExoticBirdsClient
//
//  Created by Davin Leong on 2024-11-19.
//

import SwiftUI

struct BirdDeleteView: View {
    @State private var birdId: Int = 0 // ID of the bird to delete
    @State private var isDeleting: Bool = false // To track if the request is in progress
    @State private var showAlert: Bool = false // To show alert on success/failure
    @State private var alertMessage: String = "" // Message to show in the alert
    
    var body: some View {
        VStack {
            TextField("Enter Bird ID", value: $birdId, format: .number)
                .padding()
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                deleteBird(id: birdId)
            }) {
                Text("Delete Bird")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .padding()
    }
    
    // Function to send the DELETE request
    func deleteBird(id: Int) {
        guard id > 0 else {
            alertMessage = "Invalid bird ID."
            showAlert = true
            return
        }
        
        isDeleting = true
        
        // Create the URL for the DELETE request
        guard let url = URL(string: "https://exoticbirdsapi.azurewebsites.net/api/Birds/\(id)") else {
            alertMessage = "Invalid URL"
            showAlert = true
            isDeleting = false
            return
        }
        
        // Create the URLRequest with DELETE method
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Create a data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                } else if let response = response as? HTTPURLResponse {
                    if response.statusCode == 204 {
                        alertMessage = "Bird deleted successfully."
                    } else {
                        alertMessage = "Failed to delete bird. Response code: \(response.statusCode)"
                    }
                    showAlert = true
                }
                isDeleting = false
            }
        }
        
        // Start the network request
        task.resume()
    }
}

//#Preview {
//    BirdDeleteView()
//}
