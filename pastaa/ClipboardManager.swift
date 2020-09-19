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

class ClipboardManager {
    let listener = ClipboardListener()
    
    func copyToClipboard() {
        let random = Int.random(in: 0..<listener.clipboardHistory.count)
        writeClipboard(content: listener.clipboardHistory[random])
    }

    func writeClipboard(content: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(content, forType: NSPasteboard.PasteboardType.string)
    }
}


class ClipboardListener {
    let interval = 1
    var previous = ""
    var timer = Timer()
    var clipboardHistory: [String] = []
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkClipboard), userInfo: nil, repeats: true)
    }
    
    @objc
    func checkClipboard() {
        let currClipboard = NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string)
        if currClipboard != previous {
            previous = currClipboard ?? ""
            clipboardHistory.append(previous)
            print("Clipboard changed \(previous)")
        }
    }
}

