//
//  BirdCreateView.swift
//  ExoticBirdsClient
//
//  Created by Davin Leong on 2024-11-19.
//

import SwiftUI
import UIKit

struct BirdCreateView: View {
    @State private var birdName: String = ""
    @State private var birdDescription: String = ""
    @State private var birdCountries: String = ""
    @State private var birdWidth: Int = 0
    @State private var birdBase64Image: String = ""

    @State private var imageToDisplay: UIImage? = nil
    @State private var isSubmitting: Bool = false

    @State private var showImagePicker: Bool = false
    @State private var selectedImageData: Data? = nil
    
    @State private var showAlert: Bool = false
    @State private var errorMsg: String = ""

    
    var body: some View {
        VStack {
            Text("Create New Bird")
                .font(.largeTitle)
                .padding()
            
            // Alert
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Validation Error"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
            }

            // Bird Name
            TextField("Bird Name", text: $birdName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Bird Description
            TextField("Bird Description", text: $birdDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Countries
            TextField("Countries", text: $birdCountries)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Width
            TextField("Width", value: $birdWidth, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)  // Allows only numeric input
                .padding()


            // Base64 Image String (This will be set after image is picked)
            if let imageToDisplay = imageToDisplay {
                Image(uiImage: imageToDisplay)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
            }

            // Select Image Button
            Button("Select Image") {
                showImagePicker.toggle()
            }
            .padding()

            // Submit Button
            Button(action: {
                // Handle the submit action (e.g., save the bird data)
                isSubmitting = true
                createBird()
            }) {
                Text(isSubmitting ? "Submitting..." : "Create Bird")
                    .font(.title2)
                    .padding()
                    .background(isSubmitting ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isSubmitting)
            .padding()

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(imageData: $selectedImageData, selectedImage: $imageToDisplay)
        }
    }

    // Function to convert selected image to base64 string and POST to backend
    func createBird() {
        // Convert selected image to base64 string
        if let imageData = selectedImageData {
            birdBase64Image = imageData.base64EncodedString()
        }
        
        // Send the bird data to the backend
        postBirdData()
    }
    
    // Function to POST the bird data to the API
    func postBirdData() {
        // Create the URL for the POST request
        guard let url = URL(string: "https://exoticbirdsapi.azurewebsites.net/api/Birds") else {
            print("Invalid URL")
            isSubmitting = false
            return
        }

        // Create the JSON body for the POST request
        let body: [String: Any] = [
            "name": birdName,
            "description": birdDescription,
            "countries": birdCountries,
            "width": birdWidth,
            "base64Image": birdBase64Image
        ]
        
        // Convert the body to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error serializing JSON data")
            isSubmitting = false
            return
        }

        // Create the URLRequest and set the HTTP method and headers
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Create a data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error sending request: \(error.localizedDescription)")
                    isSubmitting = false
                    return
                }

                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        print("Bird created successfully!")
                        // Reset the form after successful submission
                        resetForm()
                    } else {
                        // Handle validation errors in the response
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            // Parse the response data to extract error details
                            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                                var errorMessage = "Failed to create bird. Response code: \(response.statusCode)"
                                
                                // Combine error messages for each field
                                for (field, messages) in errorResponse.errors {
                                    for message in messages {
                                        errorMessage += "\n\(field): \(message)"
                                    }
                                }

                                errorMsg = errorMessage
                                showAlert = true
                            } else {
                                print("Failed to parse error response: \(responseString)")
                                errorMsg = "An unknown error occurred."
                                showAlert = true
                            }
                        } else {
                            print("Failed to create bird. Response code: \(response.statusCode), but no data received.")
                            errorMsg = "An unknown error occurred."
                            showAlert = true
                        }
                        isSubmitting = false
                    }
                }
            }
        }

        // Error response structure for decoding the API error response
        struct ErrorResponse: Codable {
            var errors: [String: [String]]
        }


        // Start the network request
        task.resume()
    }

    // Function to reset the form after successful submission
    func resetForm() {
        birdName = ""
        birdDescription = ""
        birdCountries = ""
        birdWidth = 0
        birdBase64Image = ""
        imageToDisplay = nil
        isSubmitting = false
    }
}

struct ImagePickerView: View {
    @Binding var imageData: Data?
    @Binding var selectedImage: UIImage?

    let imagePickerController = UIImagePickerController()

    var body: some View {
        ImagePickerControllerWrapper(imageData: $imageData, selectedImage: $selectedImage)
            .edgesIgnoringSafeArea(.all)
    }
}

// ImagePickerControllerWrapper handles UIKit's UIImagePickerController in SwiftUI
struct ImagePickerControllerWrapper: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // You can change to `.camera` if you want to use the camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(imageData: $imageData, selectedImage: $selectedImage)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var imageData: Data?
        @Binding var selectedImage: UIImage?

        init(imageData: Binding<Data?>, selectedImage: Binding<UIImage?>) {
            _imageData = imageData
            _selectedImage = selectedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.selectedImage = image
                self.imageData = image.jpegData(compressionQuality: 1.0) // You can use `.pngData()` for PNG format
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
  BirdCreateView()
}

