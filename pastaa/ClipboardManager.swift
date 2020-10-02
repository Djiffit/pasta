//
//  ClipboardManager.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation
import HotKey
import Cocoa
import SwiftUI

class ClipboardManager: ObservableObject {
    static let param = "<param>"
    let interval = 0.25
    var previous = ""
    var timer = Timer()
    let mainTab = "main"
    let searchTab = "search"
    @Published var currentGroups: [Group] = [Group(title: "search"), Group(title: "main")]
    @Published var activeTab = 0
    @Published var currentSearch = ""
    @Published var statusMessage = ""
    
    var fillingTemplate = false
    let frozenTabs = ["main", "search"]
    
    init() {
        activeTab = 0
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.checkClipboard), userInfo: nil, repeats: true)
        reset()
    }

    @objc
    func checkClipboard() {
        let currClipboard = NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string)
        if currClipboard != nil && currClipboard?.trimmingCharacters(in: .whitespacesAndNewlines) != previous {
            previous = (currClipboard?.trimmingCharacters(in: .whitespacesAndNewlines))!
            if previous.count > 0 {
                if let group = findGroupByName(name: mainTab) {
                    group.addEntry(entry: Entry(text: previous))
                    StorageManager.saveClipboardState(clipboard: self)
                }
            }
        }
    }
    
    func findGroupByName(name: String) -> Group? {
        return currentGroups.first(where: {(group) -> Bool in return group.title == name})
    }
    
    func openSearchTab() {
        if let ind = currentGroups.firstIndex(where: { (group) -> Bool in return group.title == searchTab }) {
            activeTab = ind
            currentGroups[activeTab].reset()
        }
//        if clipboardGroups.keys.contains(tab.title) {
//            activeTab = 1
//            let test = currentGroups.firstIndex(where: { (group) -> Bool in
//                return group == tab
//            })
//            reset()
//        }
    }
    
//    func addCommandToGroup(cmd: Entry, group: Group) {
//        var entries = clipboardGroups[group.title]
//        if (entries?.contains(cmd) != nil) {
//            entries?.removeAll(where: { $0 == cmd })
//        }
//        entries?.append(cmd)
//    }
    
    func removeCurrentCmd() {
        var _ = currentGroups[activeTab].removeCurrentCmd()
    }
    
    func activeEntry() -> Entry? {
        return currentGroups[activeTab].activeEntry()
    }
    
    // Move element to another tab
    func moveActiveElem(change: Int) {
        let currTab = currentGroups[activeTab]
        let targetTab = currentGroups[mod(activeTab + change, currentGroups.count)]
        if let elem = currTab.removeCurrentCmd() {
            targetTab.addEntry(entry: elem)
        }
        activeTab = mod(activeTab + change, currentGroups.count)
        if currentGroups[activeTab].title == searchTab {
            moveActiveElem(change: change)
        }
//        if activeInd > 0 && activeInd < activeEntries?.count ?? -1 {
//            let temp = activeEntries[activeInd]
////            removeCommandFromGroup(cmd: temp)
////            changeTab(change: change)
////            addCommandToGroup(cmd: temp, group: activeTab)
////            activeCopy = temp
////            if activeTab == searchTab {
////                moveActiveElem(change: change)
////            }
//        }
    }
    
    func shiftTab(change: Int) {
        let newPos = mod(activeTab + change, currentGroups.count)
        let newPosGroup = currentGroups[newPos]
        currentGroups[newPos] = currentGroups[activeTab]
        currentGroups[activeTab] = newPosGroup
        activeTab = newPos
    }
    
    func scrollToInd(ind: Int) {
        currentGroups[activeTab].reset()
        if currentGroups[activeTab].entries.count > ind && ind >= 0 {
        }
    }
    
    func setSearch(search: String) {
        currentSearch = search.lowercased()
        let searchGroup = findGroupByName(name: searchTab)!
        
        if currentSearch.count < 3 {
            searchGroup.entries = []
        } else {
            var elems = [Entry]()
            var set: Set<String> = []
            
            for group in currentGroups {
                if group == searchGroup { continue }
                for cmd in group.entries {
                    if cmd.matches(query: currentSearch) && !set.contains(cmd.text) {
                        elems.append(cmd)
                        set.insert(cmd.text)
                    }
                }
            }
            
            searchGroup.entries = elems
        }
        
        searchGroup.reset()
    }
    
    func goToMain() {
        activeTab = currentGroups.firstIndex(where: { (group) -> Bool in
            return group.title == mainTab
        })!
    }
    
    func addDescription(desc: String) {
        if let entry = currentGroups[activeTab].activeEntry() {
            entry.description = desc
        }
    }
    
    func changeElem(change: Int) {
        currentGroups[activeTab].changePos(change: change)
    }
    
    func changeElemPos(change: Int) {
        currentGroups[activeTab].moveEntry(change: change)
    }
    
    func openLink() {
        currentGroups[activeTab].activeEntry()?.openLink()
    }
    
    func toggleDescription() {
        if let entry = currentGroups[activeTab].activeEntry() {
            entry.showDescription = !entry.showDescription
        }
    }
    
    func insertParam(param: String) -> Bool {
        if isTemplate(word: statusMessage) {
            statusMessage = replaceFirst(baseString: statusMessage, replace: param)
        }
        return !isTemplate(word: statusMessage)
    }
    
    func insertCurrentParam() -> Bool {
        if let currentEl = currentGroups[activeTab].activeEntry() {
            return insertParam(param: currentEl.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return false
    }
    
    func startFilling() {
        if let currText = currentGroups[activeTab].activeText() {
            self.statusMessage = currText
        }
    }
    
    func startFillingAppend() {
        if let currText = currentGroups[activeTab].activeText() {
            self.statusMessage = currText + " <param>"
        }
    }
    
    func isTemplate(word: String) -> Bool {
        let range = word.range(of: #"<[\w\s]+>"#,
                                     options: .regularExpression)
        return range != nil
    }
    
    func replaceFirst(baseString: String, replace: String) -> String {
        var newString = baseString
        let range = baseString.range(of: #"<[\w\s]+>"#,
                         options: .regularExpression)
        if range != nil {
            newString.replaceSubrange(range!, with: replace)
        }
        return newString
    }
    
    func toggleCurrent() {
        if let entry = currentGroups[activeTab].activeEntry() {
            entry.open = !entry.open
        }
    }
    
    func enterTemplateMode(temp: String) {
        self.fillingTemplate = true
        self.statusMessage = "Fill: " + temp
    }
    
    func rename(newName: String) {
        if !currentGroups.contains(where: { (group) -> Bool in return group.title == newName }) && !frozenTabs.contains(newName) {
            currentGroups[activeTab].rename(newName: newName)
        }
    }
    
    func changeTab(change: Int) {
        activeTab = mod(activeTab + change, currentGroups.count)
//        reset()
    }
    
    func deleteTab() {
        if !frozenTabs.contains(currentGroups[activeTab].title) {
            currentGroups.remove(at: activeTab)
            if activeTab == currentGroups.count {
                activeTab -= 1
            }
        }
    }
    
    func reset() {
//        if let elems = clipboardGroups[activeTab] {
//            if elems.count > 0 {
//                activeInd = elems.count - 1
//            } else {
//                activeInd = -1
//            }
//        }
    }
    
    func createGroup(name: String) {
        currentGroups.append(Group(title: name))
    }
    
    func copyToClipboard(msg: String) {
        writeClipboard(content: msg)
        previous = msg
    }
    
    func createTab() {
        var tabName = "new"
        let tabNames = currentGroups.map { (group) -> String in return group.title }
        while tabNames.contains(tabName) {
            tabName = tabName + String(Int.random(in: 0...10))
        }
        currentGroups.append(Group(title: tabName))
        activeTab = currentGroups.count - 1
//        reset()
    }
    
    func copyToClipboard() {
        copyToClipboard(msg: currentGroups[activeTab].activeText()!)
    }

    func writeClipboard(content: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(content, forType: NSPasteboard.PasteboardType.string)
    }
    
    
//    func addData(elems: [Entry]) {
//        clipboardGroups[activeTab]!.append(contentsOf: elems)
//    }
}

func mod(_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}
