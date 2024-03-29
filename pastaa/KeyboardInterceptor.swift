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
    let hotKey = HotKey(key: .p, modifiers: [.option])
    let toggleWindow = HotKey(key: .v, modifiers: [.option])
    var observer: NSKeyValueObservation
    
    init(window: NSWindow, clip: ClipboardManager) {
        let app = NSRunningApplication.current
        observer = app.observe(\.isActive, changeHandler: { (label, change) in
            if !app.isActive {
                NSApp.abortModal()
                NSApp.stopModal()
                window.orderOut(nil)
            }
        })
        
        toggleWindow.keyDownHandler = { [weak self] in
            self?.toggleWindowState()
        }
        self.window = window
    }
    
    func closeWindow() {
        NSApp.abortModal()
        NSApp.stopModal()
        
        window.orderOut(nil)
        if prevTop != nil {
            prevTop!.activate(options: .activateIgnoringOtherApps)
        }
    }
    
    func toggleWindowState() {
        let app = NSRunningApplication.current
        if window.isVisible {
            closeWindow()
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


//2020-10-02 11:27:04.149345+0300 pastaa[91807:10614037] Fatal error: Duplicate keys of type 'Entry' were found in a Dictionary.
//This usually means either that the type violates Hashable's requirements, or
//that members of such a dictionary were mutated after insertion.
