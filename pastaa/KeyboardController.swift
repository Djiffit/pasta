//
//  KeyboardController.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import Foundation
import HotKey
import Cocoa
import SwiftUI

class KeyboardController {
    var window: NSWindowKeypresser!
    var keyboardListener: KeyboardInterceptor!
    var clipboard: ClipboardManager!
    var renameMode = false
    var newPrompt = ""
    var deleting = false
    var searchMode = false
    var templateFilling = false
    var templateWriting = false
    var describing = false
    
    init(wind: NSWindowKeypresser, keyboard: KeyboardInterceptor, clip: ClipboardManager) {
        window = wind
        keyboardListener = keyboard
        clipboard = clip
    }
    
    func reset() {
        renameMode = false
        newPrompt = ""
        describing = false
        deleting = false
        searchMode = false
        templateFilling = false
        templateWriting = false
    }
    
    func keyDown(with event: NSEvent) -> Bool {
        if renameMode {
            if event.keyCode == 36 { // enter
                clipboard.rename(newName: newPrompt)
                newPrompt = ""
                renameMode = false
            } else if event.keyCode == 53 { // esc
                reset()
            } else {
                newPrompt += event.characters ?? ""
            }
            if renameMode {
                clipboard.statusMessage = "Rename: " + newPrompt
            } else {
                clipboard.statusMessage = " "
            }
        } else if searchMode {
            switch event.keyCode {
            case 51:  //backspace
                if newPrompt.count > 0 {
                    newPrompt.removeLast()
                }
            case 36: // enter
                searchMode = false
                newPrompt = ""
            case 53: // esc
                reset()
            default:
                newPrompt += event.characters ?? ""
            }
            if searchMode {
                clipboard.setSearch(search: newPrompt)
            }
        } else if deleting {
            if event.characters == "y" {
                clipboard.deleteTab()
            }
            clipboard.statusMessage = ""
            deleting = false
        } else if templateWriting {
            switch event.keyCode {
            case 51:  //backspace
                if newPrompt.count > 0 && templateWriting {
                    newPrompt.removeLast()
                }
            case 36: // enter
                let last = clipboard.insertParam(param: newPrompt)
                newPrompt = ""
                if last {
                    templateFilling = false
                    clipboard.copyToClipboard(msg: clipboard.statusMessage)
                    clipboard.statusMessage = " "
                    keyboardListener.closeWindow()
                }
                templateWriting = false
            case 53:  // esc
                templateFilling = false
                if templateWriting {
                    newPrompt = ""
                }
                clipboard.statusMessage = ""
                templateWriting = false
            default:
                if templateWriting {
                    newPrompt += event.characters ?? ""
                }
            }
        } else if describing {
            
            switch event.keyCode {
            case 51:  //backspace
                if newPrompt.count > 0 {
                    newPrompt.removeLast()
                }
            case 36: // enter
                clipboard.addDescription(desc: newPrompt)
                reset()
            case 53:  // esc
                reset()
            default:
                newPrompt += event.characters ?? ""
            }
        } else {
//            print(event)
            switch event.characters {
                case "\u{1B}": // esc
                    if templateFilling {
                        if templateWriting {
                            templateWriting = false
                        } else {
                            reset()
                            clipboard.statusMessage = " "
                        }
                    }
                case "k":
                    clipboard.changeElem(change: 1)
                case "K":
                    clipboard.changeElemPos(change: 1)
                case "j":
                    clipboard.changeElem(change: -1)
                case "J":
                    clipboard.changeElemPos(change: -1)
                case "h":
                    clipboard.changeTab(change: -1)
                case "l":
                    clipboard.changeTab(change: 1)
                case "q":
                    clipboard.moveActiveElem(change: -1)
                case "e":
                    clipboard.moveActiveElem(change: 1)
                case "b":
                    clipboard.toggleCurrent()
                case "H":
                    clipboard.shiftTab(change: -1)
                case "L":
                    clipboard.shiftTab(change: 1)
                case "d":
                    clipboard.changeElem(change: -5)
                case "u":
                    clipboard.changeElem(change: 5)
                case "o":
                    clipboard.openLink()
                case "g":
                    clipboard.goToMain()
                case "n":
                    clipboard.toggleDescription()
                case "x":
                    clipboard.removeCurrentCmd()
                case "f":
                    if templateFilling {
                        let last = clipboard.insertCurrentParam()
                        newPrompt = ""
                        if last {
                            templateFilling = false
                            clipboard.copyToClipboard(msg: clipboard.statusMessage)
                            clipboard.statusMessage = " "
                            keyboardListener.closeWindow()
                        }
                    } else if clipboard.isTemplate(word: clipboard.activeEntry()!.text) {
                        templateFilling = true
                        clipboard.startFilling()
                    } else {
                        templateFilling = true
                        clipboard.startFillingAppend()
                    }
                case "v":
                    clipboard.copyToClipboard()
                    keyboardListener.closeWindow()
                case "p":
                    reset()
                    describing = true
                case "t":
                    clipboard.createTab()
                case "i":
                    if templateFilling {
                        self.templateWriting = true
                    }
                case "1":
                    clipboard.scrollToInd(ind: 0)
                case "w":
                    reset()
                    deleting = true
                    clipboard.statusMessage = "Delete Y/any"
                case "r":
                    reset()
                    renameMode = true
                    clipboard.statusMessage = "Rename: "
                case "/":
                    newPrompt = ""
                    clipboard.openSearchTab()
                    clipboard.setSearch(search: "")
                    searchMode = true
                default:
                    print("dont knoow")
            }
        }
        return false
    }
}
