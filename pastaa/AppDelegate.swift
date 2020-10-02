//
//  AppDelegate.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Cocoa
import SwiftUI

class NSWindowKeypresser: NSWindow {
    var keyListener: (_: NSEvent) -> Bool? = { event in
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        if keyListener(event)! {
            super.keyDown(with: event)
        }
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindowKeypresser!
    static var globalWindow: NSWindowKeypresser?
    var statusBarItem: NSStatusItem!
    var keyboardListener: KeyboardInterceptor!
    var clipboard: ClipboardManager!
    var popover = NSPopover()
    var localKeyboard: KeyboardController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        clipboard = StorageManager.createClipboard()
        window = initializeWindow()
        AppDelegate.globalWindow = window
        keyboardListener = KeyboardInterceptor(window: window, clip: clipboard)
        createStatusBar()
        localKeyboard = KeyboardController(wind: window, keyboard: keyboardListener, clip: clipboard)
        window.keyListener = localKeyboard.keyDown
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.title = "💩📋💩"
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func initializeWindow() -> NSWindowKeypresser {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(clipboard: clipboard)
        
        // Create the window and set the content view.
        let window = NSWindowKeypresser(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Pasta Master")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.hidesOnDeactivate = true
        window.canHide = true
        window.collectionBehavior = NSWindow.CollectionBehavior.moveToActiveSpace
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
        window.orderOut(nil)
        
        
        
        return window
    }
    
    func createStatusBar() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView(clipboard: clipboard))
        self.popover = popover
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("Terminating applications")
    }
}
