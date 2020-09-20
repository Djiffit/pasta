//
//  KeyboardInterceptor.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation
import HotKey
import Cocoa
import SwiftUI

class KeyboardInterceptor {
    var window: NSWindow!
    var prevTop: NSRunningApplication?
    var currModal: NSApplication.ModalResponse?
    var modalSession: NSApplication.ModalSession?
    let hotKey = HotKey(key: .p, modifiers: [.option])
    let toggleWindow = HotKey(key: .v, modifiers: [.option])
    
    init(window: NSWindow, clip: ClipboardManager) {
        hotKey.keyDownHandler = { [weak self] in
            clip.copyToClipboard(msg: "asdasdASD")
        }
        
        toggleWindow.keyDownHandler = { [weak self] in
            self?.toggleWindowState()
        }
        
        self.window = window
    }
    
    func toggleWindowState() {
        let app = NSRunningApplication.current
        if window.isVisible {
            NSApp.abortModal()
            window.orderOut(nil)
            if prevTop != nil {
                prevTop!.activate(options: .activateIgnoringOtherApps)
            }
        } else {
            prevTop = NSWorkspace.shared.frontmostApplication!
            if !app.isActive {
                app.activate(options: .activateIgnoringOtherApps)
            }
            NSApp.runModal(for: window)
            window.center()
        }
    }
    
}


