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
        astronomyViewModel.delegate = self
        astronomyViewModel.getAstronomyDataFromNetwork()
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
            updateUI(astronomyData)
        }
    }
    
    func updateUI(_ astronomyData: Astronomy) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = astronomyData.title
            self?.explanationLabel.text = astronomyData.explanation
        }
    }
    
}
