//
//  CodeTokenizer.swift
//
//
//  Created by Brad Slayter on 5/22/24.
//

import Foundation

struct CodeTokenizer {
    func getTokens(from string: String, exclude currentToken: String?) -> Set<String> {
        let comps = string.components(separatedBy: CharacterSet(charactersIn: " \n\t(="))

        let tokenSet = Set(comps).filter({
            !$0.isEmpty &&                                               // not empty
            $0.rangeOfCharacter(from: .alphanumerics.inverted) == nil && // no symbols
            $0.rangeOfCharacter(from: .letters) != nil &&                // must contain a letter
            $0 != currentToken                                           // exclude the current token
        })

        return tokenSet
    }
}
