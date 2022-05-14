//
//  AstronomyViewModel.swift
//  APOD
//
//  Created by aksagarw on 14/05/22.
//

import Foundation

protocol AstronomyDataDelegate {
    func didFetchAstronomyData(_ astronomyData: Astronomy?,_ error: Error?)
}

class AstronomyViewModel {
        
    var delegate: AstronomyDataDelegate?
    
    func getAstronomyDataFromNetwork() {
        NetworkService.shared.getAstronomyData(completion: { [weak self] data, error in
            self?.delegate?.didFetchAstronomyData(data, error)
        })
    }
}
