//
//  MainView.swift
//  Salt
//
//  Created by Gordon Gooi on 21/12/21.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    init() {
        //          UITableView.appearance().backgroundColor = .clear // For tableView
        UITableViewCell.appearance().backgroundColor = .clear // For tableViewCell
    }
    var body: some View {
        NavigationView{
            List {
                Section {
                    VStack {
                        Text("Ttg")
                    }
                }
                Section {
                    
                    NavigationLink(destination: MapView()) {
                        Label("Map", systemImage: "map")
                    }

               
                    NavigationLink(destination: CalanderView()) {
                        Label("Calander", systemImage: "calendar")
                    }
                }
            }.navigationTitle("Salt")
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarItems(leading: LogoutButton())
            //                .background(Image("BG"))
        }
    }
}
