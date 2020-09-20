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
    let interval = 0.25
    var previous = ""
    var timer = Timer()
    @Published var activeTab = "main"
    @Published var currentGroups: [String] = ["main", "test", "masters"]
    @Published var activeCopy = ""
    @Published var clipboardGroups = [String : [String]]()
    
    init() {
        clipboardGroups["main"] = ["OG"]
        clipboardGroups["test"] = ["OG"]
        clipboardGroups["masters"] = []
        for el in 0...100 {
            clipboardGroups["main"]?.append("Tester master \(el)")
        }
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.checkClipboard), userInfo: nil, repeats: true)
        reset()
    }

    @objc
    func checkClipboard() {
        let currClipboard = NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string)
        if currClipboard != previous {
            previous = currClipboard ?? ""
            if previous.count > 0 {
                addCommandToGroup(cmd: previous, group: "main")
            }
        }
    }
    
    func setActiveTab(tab: String) {
        if clipboardGroups.keys.contains(tab) {
            activeTab = tab
        }
    }
    
    func removeCommandFromGroup(cmd: String) {
        clipboardGroups[activeTab] = clipboardGroups[activeTab]?.filter({(x) -> Bool in
            return x != cmd
        })
    }
    
    func addCommandToGroup(cmd: String, group: String) {
        if ((clipboardGroups[group]?.contains(cmd)) != nil) {
            clipboardGroups[group]?.removeAll(where: { $0 == cmd })
        }
        clipboardGroups[group]?.append(cmd)
    }
    
    func moveActiveElem(change: Int) {
        if activeCopy != "" {
            let temp = activeCopy
            removeCommandFromGroup(cmd: temp)
            changeTab(change: change)
            addCommandToGroup(cmd: temp, group: activeTab)
            activeCopy = temp
        }
    }
    
    func changeElem(change: Int) {
        let currGroup = clipboardGroups[activeTab]!
        if activeCopy != "" {
            let currInd = currGroup.firstIndex(of: activeCopy)
            activeCopy = currGroup[mod(currInd! + change, currGroup.count)]
        } else {
            if currGroup.count > 0 {
                activeCopy = currGroup[currGroup.count - 1]
            }
        }
    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
    func openLink() {
        if let link = URL(string: activeCopy) {
            if activeCopy.contains("/") && activeCopy.contains(".") {
                NSWorkspace.shared.open((activeCopy.contains("http") ? link : URL(string: "https://" + activeCopy)) ?? link)
            }
        }
    }
    
    func rename(newName: String) {
        if !currentGroups.contains(newName) {
            clipboardGroups[newName] = clipboardGroups[activeTab]
            let ind = currentGroups.firstIndex(of: activeTab)
            clipboardGroups.removeValue(forKey: activeTab)
            currentGroups[ind!] = newName
            activeTab = newName
        }
    }
    
    func changeTab(change: Int) {
        if let currInd = currentGroups.firstIndex(of: activeTab) {
            activeTab = currentGroups[mod(currInd + change, currentGroups.count)]
        } else {
            activeTab = currentGroups[0]
        }
        reset()
    }
    
    func deleteTab() {
        if activeTab != "main" {
            let removeInd = currentGroups.firstIndex(of: activeTab)!
            clipboardGroups.removeValue(forKey: activeTab)
            changeTab(change: -1)
            currentGroups.remove(at: removeInd)
        }
        
        print(currentGroups, clipboardGroups)
    }
    
    func reset() {
        if let elems = clipboardGroups[activeTab] {
            if elems.count > 0 {
                activeCopy = elems[elems.count - 1]
            } else {
                activeCopy = ""
            }
        }
    }
    
    func createGroup(name: String) {
        currentGroups.append(name)
        clipboardGroups[name] = []
    }
    
    func copyToClipboard(msg: String) {
        writeClipboard(content: msg)
        previous = msg
    }
    
    func createTab() {
        var tabName = "new"
        while currentGroups.contains(tabName) {
            tabName = tabName + String(Int.random(in: 0...10))
        }
        currentGroups.append(tabName)
        clipboardGroups[tabName] = []
        activeTab = tabName
        reset()
    }
    
    func copyToClipboard() {
        copyToClipboard(msg: activeCopy)
    }

    func writeClipboard(content: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(content, forType: NSPasteboard.PasteboardType.string)
    }
    
    
    func addData(elems: [String]) {
        clipboardGroups[activeTab]!.append(contentsOf: elems)
    }
}


