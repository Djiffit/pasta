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
    var window: NSWindow?
    var currModal: NSApplication.ModalResponse?
    var modalSession: NSApplication.ModalSession?
    let hotKey = HotKey(key: .r, modifiers: [.command, .option])
    let toggleWindow = HotKey(key: .v, modifiers: [.command, .option])
    
    init() {
        
        hotKey.keyDownHandler = { [weak self] in
            self?.setWindowState(active: false)
        }
        
        toggleWindow.keyDownHandler = { [weak self] in
            self?.setWindowState(active: true)
        }
    }
    
    func setWindowState(active: Bool) {
        var app = NSRunningApplication.current
        if (active) {
            if !app.isActive {
                app.activate(options: .activateIgnoringOtherApps)
            }
            if window == nil {
                window = initializeWindow()
            }
            if !window!.isVisible {
                NSApp.runModal(for: window!)
                window?.center()
            }
        } else {
            NSApp.abortModal()
            window?.orderOut(nil)
            window?.orderOut(nil)
        }
    }
}


