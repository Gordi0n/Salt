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
    
    var body: some View {
        NavigationView {
        GeometryReader {geometry in
        MyMapView()
        
            .cornerRadius(15)
    .frame(width: geometry.size.width * 0.95, height: geometry.size.height , alignment: .center)
    .offset(x: geometry.size.width * 0.025, y: geometry.size.height * -0.35)
}.frame(height: 300)
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


