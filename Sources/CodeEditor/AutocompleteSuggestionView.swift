//
//  AutocompleteSuggestionView.swift
//
//
//  Created by Brad Slayter on 5/21/24.
//

import SwiftUI

struct AutocompleteSuggestionView: View {

    @ObservedObject var viewModel: AutocompleteSuggestionViewModel

    var body: some View {
        List {
            ForEach(viewModel.filteredList) { suggestion in
                HStack {
                    Text(suggestion.suggestion)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.select(suggestion: suggestion)
                }
            }
        }
        .listStyle(.plain)
        .frame(width: 300)
        .frame(minHeight: 200, maxHeight: 350)
        .border(Color.primary, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let viewModel = AutocompleteSuggestionViewModel()
    viewModel.updateSuggestionList(for: "p")
    return AutocompleteSuggestionView(viewModel: viewModel)
}
