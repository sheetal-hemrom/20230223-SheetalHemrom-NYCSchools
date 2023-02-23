//
//  SchoolsViewController.swift
//  NYCSchools
//
//  Created by Sheetal on 2/23/23.
//

import UIKit
import Combine

class SchoolsViewController: UITableViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var schoolsTable: UITableView?
    
    
    // MARK: Properties
    
    let schoolsViewModel: SchoolsViewModel = SchoolsViewModel()
    var anyCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to schools array from view model
        schoolsViewModel.$schools
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.schoolsTable?.reloadData()
            })
            .store(in: &anyCancellables)
         
        // Subscribe to error message from view model
        schoolsViewModel.$alertErrorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { errorMessage in
                if let errorMessage = errorMessage {
                    self.showAlert(title: "Error", message: errorMessage)
                }else {
                    self.showAlert(title: "Error", message: StringConstants.genericError.description)
                }
            })
            .store(in: &anyCancellables)
    
        }
        
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            schoolsViewModel.fetchSchools()
        }

}

extension SchoolsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schoolsViewModel.schools.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.schoolCellIdentifier.description) as! SchoolTableViewCell
        cell.school_name = schoolsViewModel.schools[indexPath.row].name
        return cell
    }
    
    
}

