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
    @State var address: String = ""
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
                    NavigationLink(destination: MapView(address2: $address)) {
                        Label("Map", systemImage: "map")
                    }

               
                    NavigationLink(destination: CalanderView().environmentObject(locationD())) {
                        Label("Calander", systemImage: "calendar")
                    }
                }                .listRowSeparator(.hidden)
                    .accentColor(.primary)
                Section {
                    HStack {
                        Text("Workflows".uppercased())
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    VStack {
                        Text("Hello")
                    }
                }                 .listRowSeparator(.hidden)
                    .accentColor(.primary)
                Section {
                    NavigationLink(destination: AccountView()) {
                        Label("Account", systemImage: "person.crop.circle")
                    }
                }.listRowSeparator(.hidden)
                    .accentColor(.primary)
            }.navigationTitle("Salt")
                .navigationViewStyle(StackNavigationViewStyle())
               
            //                .background(Image("BG"))
        }
    }
}
