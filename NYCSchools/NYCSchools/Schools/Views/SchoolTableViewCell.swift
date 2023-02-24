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
    @IBOutlet var overviewLabel: UILabel?
    
    // MARK: Publishers
    
    @Published var school: School?
    
    // MARK: Life Cycle Functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        $school
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                self.schoolNameLabel?.text = value?.name
                self.overviewLabel?.text = value?.overview.trunc(length: 200)
            })
            .store(in: &anyCancellables)
    }
}

