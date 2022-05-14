//
//  APODViewController.swift
//  APOD
//
//  Created by aksagarw on 14/05/22.
//

import UIKit

class APODViewController: UIViewController, AstronomyDataDelegate {
    
    @IBOutlet weak var astronomyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    var astronomyViewModel = AstronomyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.lastDate == nil {
            if !Reachability.isConnectedToNetwork() {
                showNoNetworkAlert()
                fetchLastDateAstronomy()
            } else {
                astronomyViewModel.getAstronomyDataFromNetwork()
            }
        } else {
            fetchLastDateAstronomy()
        }
        astronomyViewModel.delegate = self
    }
    
    func showNoNetworkAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Not connected to Internet!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func fetchLastDateAstronomy() {
        DispatchQueue.main.async {
            self.titleLabel.text = UserDefaults.standard.value(forKey: "title") as? String
            self.explanationLabel.text = UserDefaults.standard.value(forKey: "explanation") as? String
            self.astronomyImageView.image = loadImageFromDiskWith(fileName: "astronomy")
        }
    }
    
    func didFetchAstronomyData(_ astronomyData: Astronomy?, _ error: Error?) {
        if let error = error {
            if error as! NetworkError == NetworkError.notConnected {
                print("Error occured: Not connected to Internet")
            } else {
                print("Error occured: \(error)")
            }
        }
        
        if let astronomyData = astronomyData {
            UserDefaults.lastDate = Date.now
            UserDefaults.standard.set(astronomyData.title, forKey: "title")
            UserDefaults.standard.set(astronomyData.explanation, forKey: "explanation")
            updateUI(astronomyData)
        }
    }
    
    func updateUI(_ astronomyData: Astronomy) {
        DispatchQueue.main.async { [weak self] in
            if let imageUrl = astronomyData.url {
                self?.astronomyImageView.imageFromURL(imageUrl)
            }
            self?.titleLabel.text = astronomyData.title
            self?.explanationLabel.text = astronomyData.explanation
        }
    }
    
}
