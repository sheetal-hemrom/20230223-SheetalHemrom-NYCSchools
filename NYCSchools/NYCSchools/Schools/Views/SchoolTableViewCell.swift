//
//  SchoolTableViewCell.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import UIKit
import Combine

class SchoolTableViewCell: UITableViewCell {
    
    var anyCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: IBOutlets
    
    @IBOutlet var schoolNameLabel: UILabel?
    @IBOutlet var overViewLabel: UILabel?
    
    // MARK: Publishers
    
    @Published var school_name: String?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        $school_name
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                self.schoolNameLabel?.text = value
            })
            .store(in: &anyCancellables)
    }
}

