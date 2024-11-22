//
//  BirdListView.swift
//  ExoticBirdsClient
//
//  Created by Davin Leong on 2024-11-19.
//

import SwiftUI

struct BirdReadView: View {
    @State private var bird: Bird?
    @State private var birds: [Bird] = []
    @State private var inputID: String = ""
    @State private var isLoadingOne: Bool = false // Loading state
    @State private var isLoadingAll: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                // Single Bird Lookup
                HStack {
                    TextField("Enter Bird ID", text: $inputID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad) // Suggest number pad for input
                        .padding()
                        .onChange(of: inputID) { newValue in
                            // Allow only numeric input
                            inputID = newValue.filter { $0.isNumber }
                        }
                    
                    Button("Get Bird by ID") {
                        if let id = Int(inputID) {
                            isLoadingOne = true // Start loading
                            fetchBirdByID(id: id) { fetchedBird in
                                self.bird = fetchedBird
                                self.isLoadingOne = false // Stop loading
                            }
                        }
                    }
                    .padding()
                }
                
                // Display loading or specific bird
                if isLoadingOne {
                    ProgressView("Loading...")
                        .padding()
                } else if let bird = bird {
                    VStack {
                        Text(bird.name)
                            .font(.title)
                            .padding()
                        Text(bird.description)
                            .font(.body)
                            .padding()
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)  // Allow text to wrap indefinitely (no line limit)
                            .fixedSize(horizontal: false, vertical: true)  // Allow text to grow vertically
                        Text("Countries: \(bird.countries)")
                        Text("Width: \(bird.width)")
                        if let uiImage = bird.base64Image.toUIImage() {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding()
                        } else {
                            Text("Image not available")
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Text("No bird selected")
                        .font(.subheadline)
                        .padding()
                }
                
                Divider()
                    .padding()
                Spacer()
                
                // Get All Birds Button
                Button("Get All Birds") {
                    isLoadingAll = true // Start loading
                    fetchAllBirds { fetchedBirds in
                        self.birds = fetchedBirds
                        self.isLoadingAll = false // Stop loading
                    }
                }
                .padding()
                
                // Display loading or list of all birds
                if isLoadingAll {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    List(birds, id: \.id) { bird in
                        VStack {
                            Text(bird.name)
                                .font(.title)
                                .padding()
                            Text(bird.description)
                                .font(.body)
                                .padding()
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Countries: \(bird.countries)")
                            Text("Width: \(bird.width)")
                            if let uiImage = bird.base64Image.toUIImage() {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .padding()
                            } else {
                                Text("Image not available")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }

    // Fetch a single bird by ID
    func fetchBirdByID(id: Int, completion: @escaping (Bird?) -> ()) {
        guard let url = URL(string: "https://exoticbirdsapi.azurewebsites.net/api/Birds/\(id)") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let fetchedBird = try decoder.decode(Bird.self, from: data)
                    DispatchQueue.main.async {
                        completion(fetchedBird)
                    }
                } catch {
                    print("Error decoding bird: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }

    // Fetch all birds
    func fetchAllBirds(completion: @escaping ([Bird]) -> ()) {
        guard let url = URL(string: "https://exoticbirdsapi.azurewebsites.net/api/Birds") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let fetchedBirds = try decoder.decode([Bird].self, from: data)
                    DispatchQueue.main.async {
                        completion(fetchedBirds)
                    }
                } catch {
                    print("Error decoding birds: \(error)")
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }
}

#Preview {
  BirdReadView()
}
