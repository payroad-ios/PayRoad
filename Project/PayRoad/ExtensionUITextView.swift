//
//  ExtensionUITextView.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 24..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension UITextView {
    public var lineNumber: Int {
        get {
            if self.text.characters.count == 0 {
                return 1
            }
            
            let layoutManager = self.layoutManager
            let numberOfGlyphs = layoutManager.numberOfGlyphs
            var lineRange: NSRange = NSMakeRange(0, 1)
            var index = 0
            var numberOfLines = 0
            
            while index < numberOfGlyphs {
                layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
                index = NSMaxRange(lineRange)
                numberOfLines += 1
            }
            
            if self.text.characters.last == "\n" {
                numberOfLines += 1
            }
            
            return numberOfLines
        }
    }
}

extension UITextView: UITextViewDelegate {
    
    public var placeholder: String? {
        get {
            guard let placeholderLabel = self.viewWithTag(9000) as? UILabel else {
                return nil
            }
            
            return placeholderLabel.text
        }
        set {
            if let placeholderLabel = self.viewWithTag(9000) as? UILabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                guard let value = newValue else { return }
                self.addPlaceholder(value)
            }
        }
    }
    
    private func resizePlaceholder() {
        guard let placeholderLabel = self.viewWithTag(9000) as? UILabel else {
            return
        }
        
        let labelX = self.textContainer.lineFragmentPadding
        let labelY = self.textContainerInset.top
        let labelWidth = self.frame.width - (labelX * 2) // TextView의 양끝 공백이 Label에선 존재하지 않음.
        
        var labelHeight = CGFloat(0)
        if let lineHeight = self.font?.lineHeight {
            labelHeight = lineHeight
        } else {
            labelHeight = placeholderLabel.frame.height
        }
        
        placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
    }
    
    private func addPlaceholder(_ placeholderString: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderString
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = .lightGray
        placeholderLabel.tag = 9000
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
        self.textStorage.delegate = self
    }
}

extension UITextView: NSTextStorageDelegate {
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if let placeholderLabel = self.viewWithTag(9000) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
}
