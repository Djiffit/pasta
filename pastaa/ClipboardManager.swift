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
    @Published var clipboardHistory: [String] = []
    @Published var currentGroups: [String] = ["main", "test", "masters"]
    @Published var activeCopy = ""
    
    var clipboardGroups = [String : [String]]()
    
    init() {
        clipboardGroups["main"] = ["OG"]
        clipboardGroups["test"] = ["OG"]
        clipboardGroups["masters"] = []
        for el in 0...50 {
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
                if ((clipboardGroups["main"]?.contains(previous)) != nil) {
                    clipboardGroups["main"]?.removeAll(where: { $0 == previous })
                }
                clipboardGroups["main"]?.append(previous)
                clipboardHistory = clipboardGroups[activeTab]!
            }
        }
    }
    
    func setActiveTab(tab: String) {
        if clipboardGroups.keys.contains(tab) {
            clipboardHistory = clipboardGroups[tab]!
        }
    }
    
    func changeElem(change: Int) {
        if activeCopy != "" {
            let currInd = clipboardHistory.firstIndex(of: activeCopy)
            activeCopy = clipboardHistory[mod(currInd! + change, clipboardHistory.count)]
        } else {
            if clipboardHistory.count > 0 {
                activeCopy = clipboardHistory[0]
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
            NSWorkspace.shared.open(link)
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
            clipboardHistory = clipboardGroups[activeTab]!
            if elems.count > 0 {
                activeCopy = elems[0]
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
        clipboardHistory = clipboardGroups[activeTab]!
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
    
    func getActiveList() -> [String] {
        return clipboardHistory
    }
    
    
    func addData(elems: [String]) {
        clipboardGroups[activeTab]!.append(contentsOf: elems)
        clipboardHistory = clipboardGroups[activeTab]!
    }
}


