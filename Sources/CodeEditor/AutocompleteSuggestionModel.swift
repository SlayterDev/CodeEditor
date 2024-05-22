//
//  AutocompleteSuggestionModel.swift
//
//
//  Created by Brad Slayter on 5/21/24.
//

import Foundation

struct AutocompleteSuggestion: Identifiable, Equatable, Hashable {
    let suggestion: String

    var id: String {
        return suggestion
    }
}

struct AutocompleteSuggestionModel {

    var builtinSuggestions: Set<AutocompleteSuggestion>
    var userSuggestions: Set<AutocompleteSuggestion>

    init(suggestionList: [String]) {
        self.builtinSuggestions = []
        self.userSuggestions = []
        suggestionList.forEach { builtinSuggestions.insert(AutocompleteSuggestion(suggestion: $0)) }
    }

    func suggestions(for string: String) -> [AutocompleteSuggestion] {
        return builtinSuggestions.union(userSuggestions).filter { $0.suggestion.starts(with: string) && $0.suggestion != string }
    }

    mutating func setUserSuggestions(from set: Set<String>) {
        userSuggestions = Set(set.map { AutocompleteSuggestion(suggestion: $0) })
    }

}
