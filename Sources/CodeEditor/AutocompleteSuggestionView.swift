//
//  AutocompleteSuggestionView.swift
//
//
//  Created by Brad Slayter on 5/21/24.
//

import SwiftUI

struct AutocompleteSuggestionView: View {

    @ObservedObject var viewModel: AutocompleteSuggestionViewModel

    func shapeStyle(for suggestion: AutocompleteSuggestion) -> some View {
        if #available(iOS 15.0, *) {
            return RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                .padding(.horizontal, -8)
                .padding(.vertical, 1)
                .foregroundStyle(Color.accentColor)
                .opacity(0.36)
        } else {
            return RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                .padding(.horizontal, -8)
                .padding(.vertical, 1)
                .foregroundColor(Color.accentColor)
                .opacity(0.36)
        }
    }

    var body: some View {
        List {
            ForEach(viewModel.filteredList) { suggestion in
                ZStack {
                    if suggestion == viewModel.filteredList[viewModel.selectionIndex] {
                        shapeStyle(for: suggestion)
                    }
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
