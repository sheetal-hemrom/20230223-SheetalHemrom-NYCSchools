//
//  SchoolScoreViewController.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import UIKit
import Combine

class SchoolDetailsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    lazy var schoolDetailViewModel = SchoolDetailViewModel()
    var anyCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: IBOutlets
    
    @IBOutlet var schoolName:UILabel?
    @IBOutlet var noScoresLabel:UILabel?
    @IBOutlet var linksTextView:UITextView?
    @IBOutlet var schoolOverview:UILabel?
    @IBOutlet var scoreStackView:UIStackView?
    @IBOutlet var scoreNameStackView:UIStackView?
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        addSubscriptions()
        updateScoreView()
    }
    
    // MARK: Helper Functions
    
    // Add subscriptions on viewModel's publisher properties and update UI
    func addSubscriptions(){
        // Subscribe to school obj from view model
        schoolDetailViewModel.$school
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { school in
                if let school = school {
                    self.schoolName?.text = school.name
                    self.schoolOverview?.text = school.overview
                    self.renderAttributedStringForLinks(website: school.website, phone_number: school.phone_number, email: school.email ?? "", location: school.location)
                    self.showLoader()
                    self.schoolDetailViewModel.fetchSchoolScoreForDbn(dbn: school.dbn)
                }
            })
            .store(in: &anyCancellables)
        
        // Subscribe to school obj from view model
        schoolDetailViewModel.$schoolScore
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { score in
                self.hideLoader()
                self.updateScoreView()
                if let score = score {
                    if let stackView = self.scoreStackView {
                        for (index, element) in stackView.arrangedSubviews.enumerated() {
                            if let label = element as? UILabel {
                                switch index {
                                case 0:
                                    label.text = score.num_of_sat_test_takers
                                case 1:
                                    label.text = score.sat_critical_reading_avg_score
                                case 2:
                                    label.text = score.sat_math_avg_score
                                case 3:
                                    label.text = score.sat_writing_avg_score
                                default:
                                    break
                                }
                            }
                        }
                    }
                }
            })
            .store(in: &anyCancellables)
        
        // Subscribe to error message from view model
        schoolDetailViewModel.$alertErrorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { errorMessage in
                self.hideLoader()
                if let errorMessage = errorMessage, !errorMessage.isEmpty{
                    self.showAlert(title: "Error", message: errorMessage)
                }
            })
            .store(in: &anyCancellables)
    }
    
    func renderAttributedStringForLinks(website: String, phone_number: String, email: String, location: String) {
        
        let contactUSText =
            """
            Contact Us:

            Email: \(email)
            Website: \(website)
            Address: \(location)
            Phone Number: \(phone_number)
            """
        
        linksTextView?.text = contactUSText
//        linksTextView?.addLinks([
//               website: website,
//               email: email,
//               phone_number: phone_number,
//               location: location
//           ])
//        linksTextView?.onLinkTap = { url in
//            // N:B URLs are currently not opening.
//            if UIApplication.shared.canOpenURL(url){
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            }
//            return true
//           }
    }
    
    func updateScoreView() {
        let shouldShowScoreView = (schoolDetailViewModel.schoolScore != nil)
        self.noScoresLabel?.text = !shouldShowScoreView ? StringConstants.noScoresMessage.rawValue: ""
        self.scoreStackView?.isHidden = !shouldShowScoreView
        self.scoreNameStackView?.isHidden = !shouldShowScoreView
    }
}

// MARK: Extensions
extension SchoolDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}


