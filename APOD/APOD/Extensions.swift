//
//  Extensions.swift
//  APOD
//
//  Created by aksagarw on 14/05/22.
//

import Foundation
import UIKit

extension UIImageView {
    func imageFromURL(_ url: String) {
        if Reachability.isConnectedToNetwork() {
            if let imageUrl = URL(string: url) {
                URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print("Error getting image: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let image = UIImage(data: data) {
                                self.image = image
                                saveImage(imageName: "astronomy", image: image)
                            }
                        }
                    }
                }).resume()
            }
        } else {
            print("Network error happened")
        }
    }
}

extension UserDefaults {
    static let defaults = UserDefaults.standard
    
    static var lastDate: Date? {
        get {
            return defaults.object(forKey: "lastDate") as? Date
        }
        set {
            guard let newValue = newValue else { return }
            guard let lastDate = lastDate else {
                defaults.set(newValue, forKey: "lastDate")
                return
            }
            
            if !Calendar.current.isDateInToday(lastDate) {
                print("remove Persistent Domain")
                UserDefaults.reset()
            }
            defaults.set(newValue, forKey: "lastDate")
        }
    }
    
    static func reset() {
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
    }
}
