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

    let suggestionsModel: AutocompleteSuggestionModel

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
        "while"
    ]

    weak var delegate: AutocompleteSuggestionDelegate?

    @Published var filteredList: [AutocompleteSuggestion] = []

    init() {
        self.suggestionsModel = AutocompleteSuggestionModel(suggestionList: pythonTokens)
    }

    func updateSuggestionList(for string: String) {
        filteredList = suggestionsModel.suggestions(for: string)
    }

    func select(suggestion: AutocompleteSuggestion) {
        delegate?.didSelectAutocompleteSuggestion(sugestion: suggestion)
    }

}
