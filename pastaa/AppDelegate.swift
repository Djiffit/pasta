//
//  AppDelegate.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var statusBarItem: NSStatusItem!
    var keyboardListener: KeyboardInterceptor!
    var clipboard: ClipboardManager!
    var popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = initializeWindow()
        clipboard = ClipboardManager()
        keyboardListener = KeyboardInterceptor(window: window, clip: clipboard)
        createStatusBar()
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
    
    func createStatusBar() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())
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
