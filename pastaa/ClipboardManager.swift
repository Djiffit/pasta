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

func writeClipboard(content: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(content, forType: NSPasteboard.PasteboardType.string)
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
        print(currClipboard)
        if currClipboard != previous {
            previous = currClipboard ?? ""
            clipboardHistory.append(previous)
        }
        print(timer.fireDate)
    }
}
