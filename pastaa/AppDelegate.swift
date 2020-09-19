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
    var keyboardListener: KeyboardInterceptor!
    var clipboardListener: ClipboardListener!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        keyboardListener = KeyboardInterceptor()
        clipboardListener = ClipboardListener()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("Terminating applications")
    }


}
