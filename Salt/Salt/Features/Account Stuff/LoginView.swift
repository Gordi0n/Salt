//
//  LoginView.swift
//  FocusawithRealm
//
//  Created by Gordon Gooi on 13/12/21.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    // Hold an error if one occurs so we can display it.
    @State var error: Error?
    
    // Keep track of whether login is in progress.
    @State var isLoggingIn = false
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoggingIn {
                    ProgressView()
                }
                if let error = error {
                    Text("Error: \(error.localizedDescription)")
                }
                NavigationLink(destination: EmailLoginView()) {
                    Label("Login with email", systemImage: "person.crop.circle")
                }
                Text("Alternatively")
                Button("Login anonymously") {
                    // Button pressed, so log in
                    isLoggingIn = true
                    app!.login(credentials: .anonymous) { result in
                        isLoggingIn = false
                        if case let .failure(error) = result {
                            print("Failed to log in: \(error.localizedDescription)")
                            // Set error to observed property so it can be displayed
                            self.error = error
                            return
                        }
                        // Other views are observing the app and will detect
                        // that the currentUser has changed. Nothing more to do here.
                        print("Logged in")
                    }
                }.disabled(isLoggingIn)
                Spacer()
                Text("Don't have an account?")
                NavigationLink(destination: Createaccount()) {
                    Label( "Create One", systemImage:"plus.square")
                }
                /*                if created == true {
                    Text("Account Successfully Created.")
                } */
            }
        }
    }
}


struct EmailLoginView: View {
    @State public var email: String = "salt"
    @State public var password: String = "22122006"
    @State var isLoggingIn = false
    @State var error: Error?
    
    var body: some View {
        
        VStack{
            HStack{
                Label("Email: ", systemImage: "envelope")
                ZStack{
                    TextField("", text: $email)
                    //                    RoundedRectangle(cornerRadius: 20)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                        .frame(width: 240, height: 40)
                    
                }
            }.offset(x: 20)
            HStack{
                Label("Password: ", systemImage: "key")
                ZStack {
                    SecureField("", text: $password)
                    //                    RoundedRectangle(cornerRadius: 20)                        .
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                        .frame(width: 240, height: 40)
                }
            }.offset(x: 23)
            Button("Login") {
                app!.login(credentials: .emailPassword(email: email, password: password)) { result in
                    isLoggingIn = false
                    if case let .failure(error) = result {
                        print("Failed to log in: \(error.localizedDescription)")
                        // Set error to observed property so it can be displayed
                        self.error = error
                        return
                    }
                    // Other views are observing the app and will detect
                    // that the currentUser has changed. Nothing more to do here.
                    print("Logged in")
                }
            }.disabled(isLoggingIn)
        }
    }
}

struct Createaccount: View {
    @State public var email: String = ""
    @State public var password: String = ""
    @State private var confirmpassword: String = ""
    @State var isLoggingIn = false
    @State var error: Error?
    @State var showLoginReturnView: Bool = false
    @State public var notcreated: Bool = true
    var body: some View {
            VStack {
                Spacer()
                HStack{
                    Label("Email: ", systemImage: "envelope")
                    TextField("", text: $email)
                    //                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 240, height: 40)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                }.offset(x: 20)
                HStack{
                    Label("Password: ", systemImage: "key")
                    ZStack {
                        SecureField("", text: $password)
                        //                    RoundedRectangle(cornerRadius: 20)
                            .frame(width: 240, height: 40)
                            .disableAutocorrection(true)
                            .autocapitalization(UITextAutocapitalizationType.none)
                    }
                }.offset(x: 23)
                HStack{
                    Label("Confirm Password: ", systemImage: "key")
                    ZStack {
                        SecureField("", text: $confirmpassword)
                        //                    RoundedRectangle(cornerRadius: 20)
                            .frame(width: 240, height: 40)
                            .disableAutocorrection(true)
                            .autocapitalization(UITextAutocapitalizationType.none)
                    }
                }.offset(x: 23)
                
                Button("Create Account") {
 //                   let passsame: Bool = password == confirmpassword
 //                   if passsame == true {
                    app!.emailPasswordAuth.registerUser(email: email, password: password) { (error) in
                        guard error == nil else {
                            print("Failed to register: \(error!.localizedDescription)")
                            
                            return
                        }
                        print("Successfully registered user.")
                        withAnimation{
                            notcreated.toggle()
                        }
                        return
                    }
  //                  }
//                    else {
//                        .alert(item: Text("Password")) { show in
 //                       Alert(title: Text("Passwords Do not Match"), message: Text("Please double check your password entries as they appear different"), dismissButton: .cancel())
 //                   }
                        
                    }
                    
                }.disabled(isLoggingIn)
                
                Spacer()
                
            
/*        if notcreated == true {
            Alert(title: Text("Account Creation Failed"), message: Text("An error occured while creating your account. Please try again."), dismissButton: .cancel())
       } */
        
        
        if notcreated == false {
            Spacer()
            Text("Account Successfully created. Click the back")
                .frame(width: 350, height: 10, alignment: .center)
                .offset(y: -10)
                .foregroundColor(.primary.opacity(0.3))
            Text("button above to login.")
                .frame(width: 350, height: 10, alignment: .center)
                .foregroundColor(.primary.opacity(0.3))

                
        }
    }
    
}
