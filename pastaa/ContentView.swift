//
//  ContentView.swift
//  pastaa
//
//  Created by Kutvonen, Konsta on 9/19/20.
//  Copyright © 2020 Kutvonen, Konsta. All rights reserved.
//

import SwiftUI

struct Sidebar: View {
    var groups: [String]
    var activeGroup: String
//    var setActiveGroup: (String) -> Void
    
    var body: some View {
        ZStack {
        List(groups, id: \.self) { group in
            HStack(alignment: .top) {
                Text(group)
                    .foregroundColor(group == activeGroup ? Color.red : Color(NSColor.textColor))
                    .listStyle(SidebarListStyle())
                    .font(.system(size: 15))
                    .frame(width: 155, height: 0)
                    .padding(.bottom, 20)
                .padding(.top, 16)
                    .padding(.trailing, 10)
            }.frame(minWidth: 155, idealWidth: 155, maxWidth: 155, maxHeight: .infinity)
        }.frame(minWidth: 155, idealWidth: 155, maxWidth: 155, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
        .padding(.trailing, 20)
            HStack {
                
            }.background(Color.blue)
            .blur(radius: 100)
            .frame(width: 155, height: 1000)
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var clipboard = ClipboardManager()
    
    init(clipboardManager: ClipboardManager) {
        clipboard = clipboardManager
    }
    
    var body: some View {
        HStack {
            Sidebar(groups: clipboard.currentGroups, activeGroup: clipboard.activeTab)
      
        VStack {
            
            VStack {
                List {
                    ForEach(self.clipboard.clipboardHistory.reversed(), id: \.self) { cmd in
                        HStack {
                            HistoryRow(text: cmd, active: cmd == clipboard.activeCopy, setActive: self.setActive)
                        }
                        .onTapGesture {
                            self.setActive(elem: cmd)
                        }
                        
                    }
                }
            }.padding(.top, 5)
        }
        }
    }
    
    
    func setActive(elem: String) {
        if NSEvent.modifierFlags.contains(.command) {
            if let url = URL(string: elem) {
                NSWorkspace.shared.open(url)
            }
        }
        if clipboard.activeCopy == elem {
            self.clipboard.copyToClipboard(msg: elem)
        }
        clipboard.activeCopy = elem
    }
}

struct TestView: View {
    
    @State private var showingAlert = true
    var body: some View {
        Button(action: {
        }) {
            Text("Show Alert")
        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text("Important message"), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
//        }
    }
}

//func createClipboardWithData() -> ClipboardManager {
//    let clip = ClipboardManager()
//    clip.addData(elems: ["testing", "123"])
//    return clip
//}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(clipboardManager: createClipboardWithData())
//    }
//}
