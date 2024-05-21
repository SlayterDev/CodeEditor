//
//  AutocompleteEngine.swift
//
//
//  Created by Brad Slayter on 5/20/24.
//

import UIKit

protocol AutocompleteEngineDelegate: AnyObject {
    func replaceTarget(range: NSRange, with text: String)
}

class AutocompleteEngine {

    weak var delegate: AutocompleteEngineDelegate?
    var autocompleteBuffer: String?

    var boxLocation: CGPoint = .zero

    private func charAt(_ i: Int, in textView: UXTextView) -> Character {
        return textView.text[textView.text.index(textView.text.startIndex, offsetBy: i)]
    }

    func updateAutocompleteBuffer(for textView: UXTextView) {
        var endLoc = textView.selectedRange.location + textView.selectedRange.length - 1
        var startLoc = endLoc
        var autocompTest = ""
        while charAt(startLoc, in: textView).isLetter || charAt(startLoc, in: textView).isNumber {
            autocompTest = "\(String(charAt(startLoc, in: textView)))\(autocompTest)"
            startLoc -= 1

            if startLoc < 0 {
                break
            }
        }
        self.autocompleteBuffer = autocompTest
        updateBoxPosition(textView: textView, endLoc: endLoc)
    }

    func updateBoxPosition(textView: UXTextView, endLoc: Int) {
        guard let textPos = textView.position(from: textView.beginningOfDocument, offset: endLoc) else { return }
        let rect = textView.caretRect(for: textPos)
        let customView = UIView(frame: CGRect(x: rect.origin.x, y: rect.origin.y, width: 20, height: 20))
        customView.backgroundColor = .blue
        textView.addSubview(customView)
    }

}
