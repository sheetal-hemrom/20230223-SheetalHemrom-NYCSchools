//
//  LinksTextView.swift
//  NYCSchools
//
//  Created by Sheetal on 2/25/23.
//

import Foundation
import UIKit

class LinksTextView: UITextView {
    
    // MARK: - Properties
    
    typealias Links = [String: String]
    typealias OnLinkTap = (URL) -> Bool
    var onLinkTap: OnLinkTap?
    
    // MARK: - Life Cycle Methods
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isEditable = false
        isSelectable = true
        isScrollEnabled = false //to have own size and behave like a label
        delegate = self
        //dataDetectorTypes = .all;
    }
    
    // MARK: - Helper Methods
    
    func addLinks(_ links: Links) {
        guard attributedText.length > 0  else {
            return
        }
        let mText = NSMutableAttributedString(attributedString: attributedText)
        for (linkText, urlString) in links {
            if linkText.count > 0 {
                let linkRange = mText.mutableString.range(of: linkText)
                mText.addAttribute(.link, value: urlString, range: linkRange)
            }
        }
        attributedText = mText
    }
}

// MARK: - TextViewDelegate
extension LinksTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return onLinkTap?(URL) ?? true
    }
    
    // to disable text selection
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
