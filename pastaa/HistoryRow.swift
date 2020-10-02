//
//  HistoryRow.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation
import SwiftUI

func getDescription(group: Group) -> String {
    if let entry = group.activeEntry() {
        return entry.description + " "
    }
    return " "
}
struct HistoryRows: View {
    @ObservedObject
    var group: Group
    
    var body: some View {
        VStack {
            
            Text(getDescription(group: group))
                .multilineTextAlignment(.center)
                .font(.system(size: 10))
            ZStack(alignment: .top) {
                HStack(alignment: .top) {
                    Text(group.entries.count == 0 ? "" : "\(group.entries.count - group.activeInd) / \(group.entries.count)")
                }
                .zIndex(30303)
                .multilineTextAlignment(.center)
                .font(.system(size: 9))
                .frame(height: 1)
                List {
                    ForEach(group.getWindow(), id: \.self) { cmd in
                        HStack {
                            HistoryRow(entry: cmd, active: group.isActive(entry: cmd))
                        }
                        .onTapGesture {
                            group.setActive(entry: cmd)
                        }
                    }
                }.padding(.top, 10)
                
            }
        }
    }
}

func getText(entry: Entry, active: Bool) -> String {
    if !active {
        return entry.displayText
    }
    if entry.showDescription && entry.description.count > 0 {
        return entry.description
    }
    if entry.open {
        return entry.text
    }
    return entry.displayText
}

struct HistoryRow: View {
    @ObservedObject
    var entry: Entry
    var active: Bool
    
    
    var body: some View {
        VStack() {
            VStack(alignment: .center) {
                Text(getText(entry: entry, active: active))
                    .underline(entry.link)
                    .foregroundColor(active ? Color.white : Color(NSColor.textColor))
                    .font(.system(size: 13))
//                    .fontWeight(active ? .regular : .light)
                    .multilineTextAlignment(.leading)
                    .lineLimit((entry.open && active) ? nil : 1)
	
                    .frame(height: (entry.open && active) ? nil : 10)
                
            }.padding(.vertical, 1).padding(.top, 8).padding(.horizontal, 20)
            Divider()
        }.padding(.horizontal, 15)
        .background(active ? Color(NSColor.controlAccentColor): Color(NSColor.windowBackgroundColor))
        .cornerRadius(15).overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(active ? Color(NSColor.controlAccentColor).opacity(0.25) : Color.gray.opacity(0.25), lineWidth: 1)).padding(.horizontal, 10)
    }
}

//struct LandmarkRow_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryRow(text: "testing this thing\nkopewoprkew\nasdfsadfsadf\nasdfsadfsadf\nasdfasdfsadfsadf\nasdfasdfsadf", true)
//    }
//}

