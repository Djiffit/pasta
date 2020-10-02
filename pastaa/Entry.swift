//
//  Entry.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI

class Entry: Equatable, Hashable, ObservableObject {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.text == rhs.text && lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(description)
    }
    
    var text: String
    var displayText: String
    @Published
    var description: String
    @Published
    var showDescription: Bool
    var link: Bool
    var date: Date
    @Published
    var open: Bool
    
    init(text: String) {
        self.text = text
        self.displayText = text.split(separator: "\n").map({(cmd) -> String in
            return cmd.trimmingCharacters(in: .whitespacesAndNewlines)
        }).joined(separator: " ")
        self.link = URL(string: text) != nil && text.contains("/") && text.contains(".")
        self.description = ""
        self.date = Date()
        self.open = false
        self.showDescription = false
    }
    
    convenience init (text: String, description: String) {
        self.init(text: text)
        self.description = description
    }
    
    func matches(query: String) -> Bool {
        return text.lowercased().contains(query) || description.lowercased().contains(query)
    }
    
    func openLink() {
        if link {
            NSWorkspace.shared.open((text.contains("http") ? URL(string: text) : URL(string: "https://" + text))!)
        }
    }
}
