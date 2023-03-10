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
    var isLoadingList: Bool = false
    var offset = 0
    
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make screen display variations
        showNavigationController(hidden: false)
        addSubscriptions()
        
        // Setting TableView inset to -40. Issue with UITableViewController
        self.tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0);

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StringConstants.sequeShowDetail.rawValue, let indexPath = sender as? IndexPath {
            let school = schoolsViewModel.schools[indexPath.row]
            if let destinationViewController = segue.destination as? SchoolDetailsViewController {
                destinationViewController.schoolDetailViewModel.school = school
            }
        }
    }
    
    // MARK: Helper Methods
    
    // Add subscriptions on viewModel's publisher properties and update UI
    func addSubscriptions() {
        // Subscribe to schools array from view model
        schoolsViewModel.$schools
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.updateLoadingIndicator()
                self.schoolsTable?.reloadData()
            })
            .store(in: &anyCancellables)
        
        // Subscribe to error message from view model
        schoolsViewModel.$alertErrorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { errorMessage in
                self.updateLoadingIndicator()
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
    
    func fetchMoreSchools() {
        updateLoadingIndicator(stop: false)
        schoolsViewModel.fetchSchools(offset: offset)
    }
    
    func updateLoadingIndicator(stop: Bool = true) {
        isLoadingList = !stop
        stop ? hideLoader() : showLoader()
    }
    
}

// MARK: Table View Delegate and Datasource methods
extension SchoolsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schoolsViewModel.schools.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.schoolCellIdentifier.rawValue) as! SchoolTableViewCell
        cell.school = schoolsViewModel.schools[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: StringConstants.sequeShowDetail.rawValue, sender: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Fetch more rows once user has scrolled outside the contentSize
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            offset = offset + IntegerConstants.defaultPaginationBatchSize.rawValue
            fetchMoreSchools()
        }
    }
}

