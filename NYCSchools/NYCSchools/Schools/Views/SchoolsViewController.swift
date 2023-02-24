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
        self.showNavigationController(hidden: false)
        showLoader()
        schoolsViewModel.fetchSchools()
        }
        
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            addSubscriptions()
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StringConstants.sequeShowDetail.rawValue, let indexPath = sender as? IndexPath {
            let school = schoolsViewModel.schools[indexPath.row]
            if let destinationViewController = segue.destination as? SchoolDetailsViewController {
                destinationViewController.schoolDetailViewModel.school = school
            }
        }
    }
    
    func addSubscriptions() {
        // Subscribe to schools array from view model
        schoolsViewModel.$schools
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.hideLoader()
                self.schoolsTable?.reloadData()
            })
            .store(in: &anyCancellables)
         
        // Subscribe to error message from view model
        schoolsViewModel.$alertErrorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { errorMessage in
                self.hideLoader()
                if let errorMessage = errorMessage, !errorMessage.isEmpty{
                    self.showAlert(title: "Error", message: errorMessage)
                }
            })
            .store(in: &anyCancellables)
    }
    
    func showNavigationController(hidden: Bool = false){
        self.navigationController?.setNavigationBarHidden(hidden, animated: true)
        self.navigationItem.title =  Bundle.main.displayName ?? StringConstants.appName.rawValue
    }

}

// MARK: Table View Delegate and Datasource methods
extension SchoolsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schoolsViewModel.schools.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.schoolCellIdentifier.rawValue) as! SchoolTableViewCell
        cell.school_name = schoolsViewModel.schools[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: StringConstants.sequeShowDetail.rawValue, sender: indexPath)
    }
    
}

