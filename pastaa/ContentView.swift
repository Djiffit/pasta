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
        VStack(alignment: .center) {
            HStack {
                List(groups, id: \.self) { group in
                    Text(group)
                        .fontWeight(.light)
                        .foregroundColor(group == activeGroup ? Color.red : Color(NSColor.textColor))
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                        .opacity(0.9)
                    
                }.frame(minWidth: 155, idealWidth: 155, maxWidth: 155, maxHeight: .infinity)
                .listStyle(SidebarListStyle())
            }
            .opacity(1)
            .background(Color(NSColor.windowBackgroundColor))
        }
        
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var clipboard: ClipboardManager
    
    var body: some View {
        HStack {
//            Sidebar(groups: clipboard.currentGroups.map({ (g) -> String in
//                return g.title
//            }), activeGroup: clipboard.currentGroups[clipboard.activeTab].title
//            )
        VStack {
            
//            ZStack {
//                ForEach(0..<(clipboard.currentGroups.count), id: \.self) { index in
//                    VStack {
//
//                        VStack {
//                            Text(self.clipboard.statusMessage).multilineTextAlignment(.center).font(.system(size: 11))
//                            Text(self.clipboard.currentGroups[index].title == "search" ? "Search: " + self.clipboard.currentSearch : " ").multilineTextAlignment(.center).font(.system(size: 11))
//                        }.padding(.horizontal, 15)
//                        HistoryRows(group: self.clipboard.currentGroups[index])
//                        //                        List {
//                        //                            ForEach((self.clipboard.clipboardGroups[index] ?? []).reversed(), id: \.self) { cmd in
//                        //                                HStack {hat
//                        //                                    HistoryRow(text: cmd, active: cmd == self.clipboard.activeCopy, setActive: self.setActive)
//                        //                                }
//                        //                                .onTapGesture {
//                        //                                    self.setActive(elem: cmd)
//                        //                                }
//                        ////
//                        //                            }
//                        //                        }
//                    }.isHidden(index != self.clipboard.activeTab)
//                }
//            }.padding(.top, 5)
//
            
            
            
            

            TabView(selection: $clipboard.activeTab) {
                ForEach(0..<(clipboard.currentGroups.count), id: \.self) { index in
                    VStack {
                        VStack {
                            Text(self.clipboard.statusMessage).multilineTextAlignment(.center).font(.system(size: 11))
                            Text(self.clipboard.currentGroups[index].title == "search" && self.clipboard.currentSearch.count > 0 ? "Search: " + self.clipboard.currentSearch : " ").multilineTextAlignment(.center).font(.system(size: 11))
                        }.padding(.horizontal, 15)
                            HistoryRows(group: self.clipboard.currentGroups[index])
//                        List {
//                            ForEach((self.clipboard.clipboardGroups[index] ?? []).reversed(), id: \.self) { cmd in
//                                HStack {hat
//                                    HistoryRow(text: cmd, active: cmd == self.clipboard.activeCopy, setActive: self.setActive)
//                                }
//                                .onTapGesture {
//                                    self.setActive(elem: cmd)
//                                }
////
//                            }
//                        }
                    }
                    .tabItem {
                        Text(self.clipboard.currentGroups[index].title)
                    }
                    .tag(index)
                }
            }.padding(.top, 5)
            
            
            
            
            
            
//            ZStack {
//                ForEach(self.clipboard.currentGroups, id: \.self) { group in
//                    List {
//                        ForEach((self.clipboard.clipboardGroups[group] ?? []).reversed(), id: \.self) { cmd in
//                            HStack {
//                                HistoryRow(text: cmd, active: cmd == clipboard.activeCopy, setActive: self.setActive)
//                            }
//                            .onTapGesture {
//                                self.setActive(elem: cmd)
//                            }
//                        }
//                    }
//                    .isHidden(group != clipboard.activeTab)
//                }
//
//            }.padding(.top, 5)
        }
        }.frame(height: 1000)
    }
//    List {
//        ForEach(self.clipboard.clipboardHistory.reversed(), id: \.self) { cmd in
//            HStack {
//                HistoryRow(text: cmd, active: cmd == clipboard.activeCopy, setActive: self.setActive)
//            }
//            .onTapGesture {
//                self.setActive(elem: cmd)
//            }
//
//        }
//    }.hidden()
    
//    func setActive(elem: String) {
//        if NSEvent.modifierFlags.contains(.command) {
//            if let url = URL(string: elem) {
//                NSWorkspace.shared.open(url)
//            }
//        }
//        if clipboard.activeCopy == elem {
//            self.clipboard.copyToClipboard(msg: elem)
//        }
//        clipboard.activeCopy = elem
//    }
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
//
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
