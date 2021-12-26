//
//  ContentView.swift
//  EventKit.Example
//
//  Created by Filip Němeček on 31/07/2020.
//  Copyright © 2020 Filip Němeček. All rights reserved.
//

import SwiftUI
import EventKit
import Combine
import RealmSwift


struct CalanderView: View {
    enum ActiveSheet {
        case calendarChooser
        case calendarEdit
    }
    @Environment(\.presentationMode) var presentationMode

    @State private var showingSheet = false
    @State private var activeSheet: ActiveSheet = .calendarChooser
    
    @GestureState private var dragOffset = CGSize.zero
    
    @ObservedObject var eventsRepository = EventsRepository.shared
    
    @State private var selectedEvent: EKEvent?
    
    @ObservedObject var locationString = locationD()
    
    @State private var directions: [String] = []


    var eventStore: EKEventStore = EKEventStore()
    
    func showEditFor(_ event: EKEvent) {
        activeSheet = .calendarEdit
        selectedEvent = event
        showingSheet = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if eventsRepository.events?.isEmpty ?? true {
                        Text("No events available for this calendar selection")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    ForEach(eventsRepository.events ?? [], id: \.self) { event in
                        EventRow(event: event).onTapGesture(count: 2) {
                            let location = event.location?.replacingOccurrences(of: "\\", with: "")
                            let location2 = location?.replacingOccurrences(of: "\n", with: " ")
                            self.locationString.name = location2 ?? ""
 // This prints the location in a string foramt
                            print(locationString.name)
                        }
                        .environmentObject(locationString)

                        .onTapGesture {
                            self.showEditFor(event)
                        }
                        
                        
                        
                    }
                    Text(locationString.name)

                    
                }
                
                SelectedCalendarsList(selectedCalendars: Array(eventsRepository.selectedCalendars ?? []))
                    .padding(.vertical)
                    .padding(.horizontal, 5)
                
                Button(action: {
                    self.activeSheet = .calendarChooser
                    self.showingSheet = true
                }) {
                    Text("Select calendars")
                }
                .buttonStyle(PrimaryButtonStyle())
                NavigationLink(destination: MapView(address2: self.$locationString.name)){
                    Text("Calculate ETA")
                }
                .sheet(isPresented: $showingSheet) {
                    if self.activeSheet == .calendarChooser {
                        CalendarChooser(calendars: self.$eventsRepository.selectedCalendars, eventStore: self.eventsRepository.eventStore)
                    } else {
                        EventEditView(eventStore: self.eventsRepository.eventStore, event: self.selectedEvent)
                    }
                   
                }
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle("Calander", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "arrow.backward")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.selectedEvent = nil
                        self.activeSheet = .calendarEdit
                        self.showingSheet = true
                    }){
                        Image(systemName: "calendar.badge.plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }){
                        Image(systemName: "plus")
                    }
                }
            }
            .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                    if(value.startLocation.x < 100 && value.translation.width > 100) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
            
    }
}
