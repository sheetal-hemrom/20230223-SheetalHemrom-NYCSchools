//
//  SchoolScoreViewController.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import UIKit
import Combine

class SchoolDetailsViewController: UIViewController {
    
    // MARK: Properties
    
    lazy var schoolDetailViewModel = SchoolDetailViewModel()
    var anyCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: IBOutlets
    
    @IBOutlet var schoolName:UILabel?
    @IBOutlet var noScoresLabel:UILabel?
    @IBOutlet var schoolOverview:UILabel?
    @IBOutlet var scoreStackView:UIStackView?
    @IBOutlet var interactiveTextField:UITextField?
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubscriptions()
    }
    
    // MARK: Helper Functions
    
    func addSubscriptions(){
        // Subscribe to school obj from view model
        schoolDetailViewModel.$school
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { school in
                if let school = school {
                    self.schoolName?.text = school.name
                    self.schoolOverview?.text = school.overview
                    self.renderAttributedStringForLinks(website: school.website)
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
                if let score = score {
                    self.noScoresLabel?.text = ""
                    if let stackView = self.scoreStackView {
                        stackView.isHidden = false
                        for (index, element) in stackView.arrangedSubviews.enumerated() {
                            if let label = element as? UILabel {
                                switch index {
                                case 0:
                                    self.renderAttributedStringForScore(scoreValue: String(score.num_of_sat_test_takers), label: label)
                                case 1:
                                    self.renderAttributedStringForScore(scoreValue: String(score.sat_critical_reading_avg_score), label: label)
                                case 2:
                                    self.renderAttributedStringForScore(scoreValue: String(score.sat_math_avg_score), label: label)
                                case 3:
                                    self.renderAttributedStringForScore(scoreValue: String(score.sat_writing_avg_score), label: label)
                                default:
                                    break
                                }
                            }
                        }
                    }
                } else {
                    self.scoreStackView?.isHidden = true
                    self.noScoresLabel?.text = StringConstants.noScoresMessage.rawValue
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
    
    
    func renderAttributedStringForScore(scoreValue: String, label: UILabel) {
        label.attributedText = label.attributedText?.replacing(placeholder: "<value>", with: scoreValue)
    }
    
    func renderAttributedStringForLinks(website: String) {
        let attributedString = NSMutableAttributedString(string: "Website: ")
        attributedString.addAttribute(.link, value: website, range: NSRange(location: 0, length: attributedString.length))
        self.interactiveTextField?.attributedText = attributedString
    }
}
// MARK: Extensions
extension SchoolDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}


