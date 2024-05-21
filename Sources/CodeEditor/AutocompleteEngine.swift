//
//  AutocompleteEngine.swift
//
//
//  Created by Brad Slayter on 5/20/24.
//

import UIKit
import SwiftUI

protocol AutocompleteEngineDelegate: AnyObject {
    func replaceTarget(range: NSRange, with text: String)
}

extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) { $0.next }
            .first(where: { $0 is UIViewController })
            .flatMap { $0 as? UIViewController }
    }
}

class AutocompleteEngine {

    weak var delegate: AutocompleteEngineDelegate?
    weak var targetTextView: UXTextView?
    
    let autocompleteViewModel: AutocompleteSuggestionViewModel

    var boxLocation: CGPoint = .zero

    var autocompleteBox: UIHostingController<AutocompleteSuggestionView>?
    var targetRange: UITextRange?

    var autocompleteBoxActive: Bool {
        return autocompleteBox != nil && !autocompleteViewModel.filteredList.isEmpty
    }

    init(autocompleteViewModel: AutocompleteSuggestionViewModel = AutocompleteSuggestionViewModel()) {
        self.autocompleteViewModel = autocompleteViewModel
        self.autocompleteViewModel.delegate = self
    }

    private func charAt(_ i: Int, in textView: UXTextView) -> Character {
        return textView.text[textView.text.index(textView.text.startIndex, offsetBy: i)]
    }

    func updateAutocompleteBuffer(for textView: UXTextView) {
        guard textView.selectedRange.length <= 1 else { return }
        let endLoc = textView.selectedRange.location - 1
        var startLoc = endLoc
        var autocompTest = ""
        while charAt(startLoc, in: textView).isLetter || charAt(startLoc, in: textView).isNumber {
            autocompTest = "\(String(charAt(startLoc, in: textView)))\(autocompTest)"
            startLoc -= 1

            if startLoc < 0 {
                break
            }
        }

        if !autocompTest.isEmpty {
            let beginning = textView.beginningOfDocument
            guard let start = textView.position(from: beginning, offset: startLoc + 1),
                  let end = textView.position(from: beginning, offset: endLoc + 1) else { removeSuggestionBox(); return }
            targetRange = textView.textRange(from: start, to: end)

            autocompleteViewModel.updateSuggestionList(for: autocompTest)
            updateBoxPosition(textView: textView, endLoc: endLoc)
        } else {
            removeSuggestionBox()
        }
    }

    func setupView(in textView: UXTextView) {
        targetTextView = textView

        let view = AutocompleteSuggestionView(viewModel: autocompleteViewModel)
        let hc = UIHostingController(rootView: view)
        let parentViewController = textView.parentViewController

        parentViewController?.addChild(hc)
        textView.addSubview(hc.view)
        hc.didMove(toParent: parentViewController)
        hc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)

        autocompleteBox = hc
    }

    func removeSuggestionBox() {
        guard let autocompleteBox else { return }

        autocompleteBox.view.removeFromSuperview()
        autocompleteBox.removeFromParent()
        self.autocompleteBox = nil
    }

    func updateBoxPosition(textView: UXTextView, endLoc: Int) {
        guard !autocompleteViewModel.filteredList.isEmpty else { removeSuggestionBox(); return }
        guard let textPos = textView.position(from: textView.beginningOfDocument, offset: endLoc) else { removeSuggestionBox(); return }
        let rect = textView.caretRect(for: textPos)
        
        if autocompleteBox == nil {
            setupView(in: textView)
        }

        autocompleteBox?.view.frame.origin = CGPoint(x: rect.origin.x + 1, y: rect.origin.y + (textView.font?.lineHeight ?? 12 + 1))
    }

}

extension AutocompleteEngine: AutocompleteSuggestionDelegate {
    func didSelectAutocompleteSuggestion(sugestion: AutocompleteSuggestion) {
        guard let selectionRange = targetRange else { return }
        removeSuggestionBox()
        targetTextView?.replace(selectionRange, withText: sugestion.suggestion)
    }
}

extension AutocompleteEngine: UXCodeTextViewKeypressDelegate {
    func textViewDidPressTab(textView: UXTextView) -> Bool {
        guard autocompleteBoxActive else { return false }

        autocompleteViewModel.selectCurrentSelection()
        return true
    }
    
    func textViewDidPressUpArrowKey(textView: UXTextView) -> Bool {
        guard autocompleteBoxActive else { return false }

        autocompleteViewModel.selectPrevSuggestion()
        return true
    }
    
    func textViewDidPressDownArrowKey(textView: UXTextView) -> Bool {
        guard autocompleteBoxActive else { return false }

        autocompleteViewModel.selectNextSuggestion()
        return true
    }
    
    func textViewDidPressEscape(textView: UXTextView) -> Bool {
        guard autocompleteBoxActive else { return false }

        removeSuggestionBox()
        return true
    }
    

}
