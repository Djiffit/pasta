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
//        if defaults.value(forKey: "tabOrder") != nil {
//            let data = defaults.value(forKey: "tabData") as! [String: [String]]
//            clipboard.currentGroups = (defaults.value(forKey: "tabOrder") as! [String]).map { (name) -> Group in
//                return Group(title: name, activeInd: data[name]!.count > 0 ? 0 : -1, entries: data[name]!.map({ (entries) -> Entry in
//                    return Entry(text: entries)
//                }))
//            }
//        }
        var groups: [Group] = []
        let groupNames = defaults.value(forKey: "groupNames") as! [String]
        let entries = defaults.value(forKey: "groupEntries") as! [String: [String]]
        let descriptions = defaults.value(forKey: "groupDescriptions") as! [String: [String]]

        for group in groupNames {
            var groupEntries: [Entry] = []
            for i in 0...(descriptions[group]!.count - 1) {
                groupEntries.append(Entry(text: entries[group]![i], description: descriptions[group]![i]))
            }
            groups.append(Group(title: group, activeInd: 0, entries: groupEntries))
        }

        clipboard.currentGroups = groups
        return clipboard
    }
    
    static func saveClipboardState(clipboard: ClipboardManager) {
        let defaults = UserDefaults.standard
        defaults.setValue(clipboard.currentGroups.map({ (group) -> String in
            return group.title
        }), forKey: "groupNames")
        var entries = [String: [String]]()
        var descriptions = [String: [String]]()
        for group in clipboard.currentGroups {
            entries[group.title] = group.entries.map({ (entry) -> String in
                return entry.text
            })
            descriptions[group.title] = group.entries.map({ (entry) -> String in
                return entry.description
            })
            
            assert(entries[group.title]!.count == descriptions[group.title]!.count)
        }
        defaults.setValue(entries, forKey: "groupEntries")
        defaults.setValue(descriptions, forKey: "groupDescriptions")
        
//        defaults.setValue(clipboard.clipboardGroups, forKey: "tabData")
    }
}
