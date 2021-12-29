//
//  MapViewFrame.swift
//  Salt
//
//  Created by Gordon Gooi on 23/12/21.
//

import SwiftUI

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State private var directions: [String] = []
    @ObservedObject var address = locationD()
    @State private var showDirections = false
    @Binding var address2: String
    @State private var eta: [String] = []


    
    var body: some View {
        NavigationView {
            VStack {
        GeometryReader {geometry in
            MyMapView(directions: $directions, eta: $eta, address: $address2)
        
            .cornerRadius(15)
    .frame(width: geometry.size.width * 0.95, height: geometry.size.height , alignment: .center)
    .offset(x: geometry.size.width * 0.025, y: geometry.size.height * -0.35)
}.frame(height: 300)
            Button(action: {
                    self.showDirections.toggle()
                  }, label: {
                    Text("Directions")
                  })
                  .disabled(directions.isEmpty)
                  .padding()
                }.sheet(isPresented: $showDirections, content: {
                  VStack(spacing: 0) {
                    Text("Directions")
                      .font(.largeTitle)
                      .bold()
                      .padding()
                    
                    Divider().background(Color.blue)
                    
                    List(0..<self.eta.count, id: \.self) { i in //change eta to directions for directions
                        Text(self.eta[i]).padding()
                    }
                  }
                })
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "arrow.backward")
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


