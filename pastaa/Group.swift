//
//  Group.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI


class Group: Equatable, ObservableObject {
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.title == rhs.title
    }
    
    let maxEntries = 22
    var title: String
    @Published
    var activeInd = 0
    @Published
    var entries: [Entry] = []
    
    init(title: String) {
        self.title = title
    }
    
    init (title: String, activeInd: Int, entries: [Entry]) {
        self.title = title
        self.activeInd = activeInd
        setEntries(entries: entries)
    }
    
    func setEntries(entries: [Entry]) {
        self.entries = entries
        reset()
    }
    
    func setActive(entry: Entry) {
        if entries.contains(entry) {
            activeInd = entries.firstIndex(of: entry)!
        }
    }
    
    func getWindow() -> [Entry] {
        if entries.count <= maxEntries {
            return entries.reversed()
        }
        
        var afterActive = entries[max(0, activeInd - (maxEntries - 5))..<min(entries.count, activeInd + 5)]
        if afterActive.count == maxEntries {
            return Array(afterActive).reversed()
        }
        
        var ind = activeInd - (maxEntries - 5) - 1
        
        while afterActive.count < maxEntries && ind >= 0 {
            afterActive = [entries[ind]] + afterActive
            ind -= 1
        }
        
        return Array(afterActive).reversed()
    }
    
    func addEntry(entry: Entry) {
        if entries.contains(entry) {
            return
        }
        entries.append(entry)
        self.activeInd = entries.count - 1
    }
    
    func rename(newName: String) {
        self.title = newName
    }
    
    func removeCommandFromGroup(cmd: String) {
        if !validInd() { return }
        
        entries = entries.filter({(x) -> Bool in
            return x.text != cmd
        })
    }
    
    func validInd() -> Bool {
        return activeInd >= 0 && activeInd < entries.count
    }
    
    func activeEntry() -> Entry? {
        if validInd() {
            return entries[activeInd]
        }
        return nil
    }
    
    func activeText() -> String? {
        return activeEntry()?.text
    }
    
    func removeCurrentCmd() -> Entry? {
        if validInd() {
            let res = entries.remove(at: activeInd)
            if !validInd() { activeInd -= 1 }
            return res
        }
        return nil
    }
    
    func reset() {
        activeInd = entries.count - 1
    }
    
    func isActive(entry: Entry) -> Bool {
        return validInd() && entries[activeInd] == entry
    }
    
    func changePos(change: Int) {
        if validInd() {
//            activeInd = mod(activeInd + change, self.entries.count)
            activeInd = min(entries.count - 1, max(0, activeInd + change))
        }
    }
    
    func moveEntry(change: Int) {
        if validInd() && entries.count > 1 {
            let currElem = entries[activeInd]
            let otherInd = mod(activeInd + change, entries.count)
            entries[activeInd] = entries[otherInd]
            entries[otherInd] = currElem
            activeInd = mod(activeInd + change, entries.count)
        }
    }
}
