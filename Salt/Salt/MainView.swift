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
        UITableView.appearance().backgroundColor = .clear // For tableView
        UITableViewCell.appearance().backgroundColor = .clear // For tableViewCell
    }
    @StateObject private var locationString = locationD()
    var body: some View {
        NavigationView{
            List {
                Section {
                    HStack {
                        Text("Features".uppercased())
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    NavigationLink(destination: MapView()) {
                        Label("Map", systemImage: "map")
                    }

               
                    NavigationLink(destination: CalanderView().environmentObject(locationD())) {
                        Label("Calander", systemImage: "calendar")
                    }
                }
                Section {
                    HStack {
                        Text("Workflows".uppercased())
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary.opacity(0.7))
                    }
                }
            }.navigationTitle("Salt")
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarItems(leading: LogoutButton())
            //                .background(Image("BG"))
        }
    }
}
