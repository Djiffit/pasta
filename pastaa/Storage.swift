//
//  Storage.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/20/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation

class StorageManager {
    static func createClipboard() -> ClipboardManager {
        let defaults = UserDefaults.standard
        let clipboard = ClipboardManager()
        clipboard.currentGroups = defaults.value(forKey: "tabOrder") as! [String]
        clipboard.clipboardGroups = defaults.value(forKey: "tabData") as! [String: [String]]
        return clipboard
    }
    
    static func saveClipboardState(clipboard: ClipboardManager) {
        let defaults = UserDefaults.standard
        defaults.setValue(clipboard.currentGroups, forKey: "tabOrder")
        defaults.setValue(clipboard.clipboardGroups, forKey: "tabData")
        print("saved state", clipboard.currentGroups)
    }
}
