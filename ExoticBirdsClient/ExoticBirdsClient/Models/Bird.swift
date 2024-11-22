//
//  Bird.swift
//  ExoticBirdsClient
//
//  Created by Davin Leong on 2024-11-19.
//

import Foundation
import UIKit

struct Bird : Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var countries: String
    var base64Image: String
    var width: Int
    
    // Convert Base64 string to UIImage
    func toUIImage() -> UIImage? {
        guard let data = Data(base64Encoded: base64Image) else { return nil }
        return UIImage(data: data)
    }
}

extension String {
    /// Converts a Base64 string to a UIImage
    func toUIImage() -> UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return UIImage(data: data)
    }
}

