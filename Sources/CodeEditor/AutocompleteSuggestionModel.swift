//
//  AutocompleteSuggestionModel.swift
//
//
//  Created by Brad Slayter on 5/21/24.
//

import Foundation

struct AutocompleteSuggestion: Identifiable {
    let suggestion: String

    var id: String {
        return suggestion
    }
}

struct AutocompleteSuggestionModel {

    let suggestions: [AutocompleteSuggestion]

    init(suggestionList: [String]) {
        self.suggestions = suggestionList.map { AutocompleteSuggestion(suggestion: $0) }
    }

    func suggestions(for string: String) -> [AutocompleteSuggestion] {
        return suggestions.filter { $0.suggestion.starts(with: string) }
    }

}
