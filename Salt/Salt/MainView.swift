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
                GeometryReader {geometry in
                    Section {
                        
                        MyMapView()
                            .cornerRadius(15)
                    }.frame(width: geometry.size.width * 0.95, height: geometry.size.height , alignment: .center)
                        .offset(x: geometry.size.width * 0.025)
                }.frame(height: 300)
              
            }.navigationTitle("Salt")
                .navigationBarItems(leading: LogoutButton())
            //                .background(Image("BG"))
        }
    }
}
