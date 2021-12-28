//
//  AccountView.swift
//  Salt
//
//  Created by Gordon Gooi on 24/12/21.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        LogoutButton()
            .foregroundColor(.red)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
