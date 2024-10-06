//
//  DetailsHTMLTextViewModel.swift
//  flickr
//
//  Created by Theo Ntogiakos on 27/09/2024.
//

import SwiftUI

class DetailsHTMLTextViewModel: ObservableObject {
    @Published var attributedString: AttributedString = AttributedString("")
    
    private func convertToAttributedString(text: String) -> AttributedString {
        
        if text.isEmpty {
            var attributedString = AttributedString("-")
            attributedString.font = .caption
            return attributedString
        }
        
        guard let data = text.data(using: .utf8) else {
            return AttributedString("-")
        }
        
        if let nsAttributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ),
           var attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
            attributedString.font = .caption
            return attributedString
        } else {
            return AttributedString("-")
        }
    }
    
    func updateAttributedString(text: String) {
        Task {
            let attributedString = convertToAttributedString(text: text)
            await MainActor.run {
                self.attributedString = attributedString
            }
        }
    }
}

