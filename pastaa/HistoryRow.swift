//
//  HistoryRow.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation
import SwiftUI


struct HistoryRow: View {
    var text: String
    var link: Bool
    var setActive: (_: String) -> Void
    let active: Bool
    
    init(text: String, active: Bool, setActive: @escaping (_: String) -> Void) {
        self.text = text.split(separator: "\n").map({(cmd) -> String in
            return cmd.trimmingCharacters(in: .whitespacesAndNewlines)
        } ).joined(separator: " ")
        link = URL(string: text) != nil && text.contains("/") && text.contains(".")
        self.active = active
        self.setActive = setActive
    }
    
    var body: some View {
        VStack() {
            VStack(alignment: .center) {
                Text(text)
                    .underline(link)
//                    .foregroundColor(link ? .blue : .green)
                    .foregroundColor(active ? Color(NSColor.controlTextColor) : Color(NSColor.textColor))
                    .font(.system(size: 12))
                    .fontWeight(.light)
                    .lineLimit(1)
                    .frame(height: 10)
                
            }.padding(.vertical, 1).padding(.top, 8).padding(.horizontal, 20)
            Divider()
        }.padding(.horizontal, 15).background(active ? Color(NSColor.selectedTextBackgroundColor): Color(NSColor.textBackgroundColor)).cornerRadius(5).overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)).padding(.horizontal, 10)
    }
}

//struct LandmarkRow_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryRow(text: "testing this thing\nkopewoprkew\nasdfsadfsadf\nasdfsadfsadf\nasdfasdfsadfsadf\nasdfasdfsadf", true)
//    }
//}
