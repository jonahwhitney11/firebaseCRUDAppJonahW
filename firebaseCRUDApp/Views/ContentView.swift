//
//  ContentView.swift
//  firebaseCRUDApp
//
//  Created by Jonah Whitney on 4/1/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    
    @State var name = ""
    @State var color = ""
    @State var variety = ""
    
    var body: some View {
        
        VStack {
            
            List (model.list) { item in
                
                HStack {
                    Text(item.name)
                    Spacer()
                    
                    // update button
                    Button(action: {
                        model.updateData(wineToUpdate: item)
                    }, label: {
                        Text("Update")
                            
                    })
                    .buttonStyle(BorderedButtonStyle())
                    
                    
                    // delete button
                    Button(action: {
                        model.deleteData(wineToDelete: item)
                    }, label: {
                        Text("Delete")
                            
                    })
                    .foregroundColor(.red)
                    .buttonStyle(BorderedButtonStyle())
                    
                }
            }
            
            Divider()
            
            VStack(spacing: 5) {
                
                // label for the add new wine section
                Text("Add new wine information below")
                    .padding(.bottom)
                
                // text fields for user input into new wine
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Color", text: $color)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Variety", text: $variety)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // button to call addData method
                Button(action: {
                    
                    // call addData
                    model.addData(name: name, color: color, variety: variety)
                    
                    // clear the text fields
                    name = ""
                    color = ""
                    variety = ""
                    
                }, label: {
                    Text("Add new wine")
                })
            }
            .padding()
        }
        
    }
    init() {
        model.getData()
    }
}

#Preview {
    ContentView()
}
