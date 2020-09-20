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
        print(event)
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        if keyListener(event)! {
            super.keyDown(with: event)
        }
    }
}

@NSApplicationMain
class AppDelegate: NSWindow, NSApplicationDelegate {

    var window: NSWindowKeypresser!
    var statusBarItem: NSStatusItem!
    var keyboardListener: KeyboardInterceptor!
    var clipboard: ClipboardManager!
    var popover = NSPopover()
    var writingMode = false
    var newPrompt = ""
    var deleting = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        clipboard = ClipboardManager()
        window = initializeWindow()
        keyboardListener = KeyboardInterceptor(window: window, clip: clipboard)
        createStatusBar()
        window.keyListener = self.keyDown
    }
    
    func keyDown(with event: NSEvent) -> Bool {
        if writingMode {
            if event.keyCode == 36 {
                clipboard.rename(newName: newPrompt)
                newPrompt = ""
                writingMode = false
            } else if event.keyCode == 53 {
                newPrompt = ""
                writingMode = false
            } else {
                newPrompt += event.characters ?? ""
            }
        } else if deleting {
            if event.characters == "y" {
                clipboard.deleteTab()
            }
            deleting = false
        } else {
            switch event.characters {
            case "k":
                clipboard.changeElem(change: 1)
            case "j":
                clipboard.changeElem(change: -1)
            case "h":
                clipboard.changeTab(change: -1)
            case "l":
                clipboard.changeTab(change: 1)
            case "o":
                clipboard.openLink()
            case "v":
                clipboard.copyToClipboard()
            case "p":
                clipboard.copyToClipboard()
            case "t":
                clipboard.createTab()
            case "w":
                deleting = true
            case "r":
                writingMode = true
            default:
                print("dont knoow")
            }
        }
        return false
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
        let contentView = ContentView(clipboardManager: clipboard)

        // Create the window and set the content view.
        let window = NSWindowKeypresser(
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
//        window.orderOut(nil)
        
        
        return window
    }
    
    func createStatusBar() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView(clipboardManager: clipboard))
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

struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
