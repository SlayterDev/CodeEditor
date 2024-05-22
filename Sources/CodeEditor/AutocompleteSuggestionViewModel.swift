//
//  AutocompleteSuggestionViewModel.swift
//
//
//  Created by Brad Slayter on 5/21/24.
//

import Foundation

protocol AutocompleteSuggestionDelegate: AnyObject {
    func didSelectAutocompleteSuggestion(sugestion: AutocompleteSuggestion)
}

class AutocompleteSuggestionViewModel: ObservableObject {

    var suggestionsModel: AutocompleteSuggestionModel

    let pythonTokens: [String] = [
        "for",
        "in",
        "is",
        "print",
        "range",
        "len",
        "and",
        "or",
        "pass",
        "break",
        "continue",
        "while",
        "def",
        "del",
        "return",
        "yield",
        "global",
        "nonlocal",
        "import",
        "from",
        "class",
        "try",
        "raise",
        "assert",
        "with",
        "not"
    ]

    weak var delegate: AutocompleteSuggestionDelegate?

    @Published var filteredList: [AutocompleteSuggestion] = []
    @Published var selectionIndex: Int = 0

    init() {
        self.suggestionsModel = AutocompleteSuggestionModel(suggestionList: pythonTokens)
    }

    func isSuggestionSelected(_ suggestion: AutocompleteSuggestion) -> Bool {
        guard !filteredList.isEmpty, selectionIndex < filteredList.count else { return false }
        return suggestion == filteredList[selectionIndex]
    }

    func setUserSuggestions(from set: Set<String>) {
        suggestionsModel.setUserSuggestions(from: set)
    }

    func updateSuggestionList(for string: String) {
        filteredList = suggestionsModel.suggestions(for: string)
    }

    func selectCurrentSelection() {
        select(suggestionAt: selectionIndex)
    }

    func select(suggestion: AutocompleteSuggestion) {
        selectionIndex = 0
        delegate?.didSelectAutocompleteSuggestion(sugestion: suggestion)
    }

    func select(suggestionAt index: Int) {
        guard !filteredList.isEmpty, index < filteredList.count else { return }
        select(suggestion: filteredList[index])
    }

    func selectNextSuggestion() {
        guard !filteredList.isEmpty else { return }
        selectionIndex = (selectionIndex + 1) % filteredList.count
    }

    func selectPrevSuggestion() {
        guard !filteredList.isEmpty else { return }
        selectionIndex -= 1
        if selectionIndex < 0 {
            selectionIndex = filteredList.count - 1
        }
    }

}
