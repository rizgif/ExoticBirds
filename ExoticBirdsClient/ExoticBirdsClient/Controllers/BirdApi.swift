//
//  BirdApi.swift
//  ExoticBirdsClient
//
//  Created by Davin Leong on 2024-11-19.
//

import Foundation

class BirdApi : ObservableObject {
    let baseURL = "https://exoticbirdsapi.azurewebsites.net/api/Birds"
    
    func loadData(completion:@escaping ([Bird]) -> ()) {
        guard let url = URL(string: "http://exoticbirdsapi.azurewebsites.net/api/Birds") else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            let decoder = JSONDecoder()
            
            if let data = data {
                do {
                    let birds = try decoder.decode([Bird].self, from: data)
                    
                    // print to console for testing
                    birds.forEach{ i in
                        print(i.name)
                    }
                    
                    DispatchQueue.main.async {
                        completion(birds)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume();
    }
}
