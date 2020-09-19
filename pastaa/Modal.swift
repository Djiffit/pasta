//
//  Modal.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI

func initializeWindow() -> NSWindow {
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()

    // Create the window and set the content view.
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
    window.hidesOnDeactivate = true
    window.collectionBehavior = NSWindow.CollectionBehavior.moveToActiveSpace
    window.titleVisibility = .hidden
    window.titlebarAppearsTransparent = true
    window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
    window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
    window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
    window.orderOut(nil)
    
    
    return window
}
