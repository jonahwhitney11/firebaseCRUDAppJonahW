//
//  viewModel.swift
//  firebaseCRUDApp
//
//  Created by Jonah Whitney on 4/8/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class ViewModel: ObservableObject {
    
    @Published var list = [Wine]()
    
    func updateData(wineToUpdate: Wine) {
        
        // get a reference to the database
        let db = Firestore.firestore()
        
        // set the data to update
        db.collection("wines").document(wineToUpdate.id).setData(["name":"Updated: \(wineToUpdate.name)"], merge: true) { error in
        
            // check for error
            if error == nil {
                // no error
                
                // update the ui on the main thread
                DispatchQueue.main.async {
                    self.getData()
                }
            }
        }
    }
    
    func deleteData(wineToDelete: Wine) {
        
        // get a reference to the database
        let db = Firestore.firestore()
        
        // specify the document to delete
        db.collection("wines").document(wineToDelete.id).delete { error in
            
            // check for error
            if error == nil {
                // no error, remove from list
                
                // update the ui on the main thread
                DispatchQueue.main.async{
                    
                    // remove wine that was just deleted
                    self.list.removeAll { wine in
                        // check for wine to remove
                        return wine.id == wineToDelete.id
                        
                    }
                }
                
            }
            
        }
    }
    
    func addData(name: String, color: String, variety: String) {
        
        // get a reference to a database
        let db = Firestore.firestore()
        
        // add a document to a collection
        db.collection("wines").addDocument(data: ["name":name, "color":color, "variety":variety]) { error in
            
            // check for errors
            if error == nil {
                // no errors
                
                // call the data to get latest data
                self.getData()
                
            } else {
                // handle the error
            }
        }
    }
    
    func getData() {
        
        // get a reference to the database
        let db = Firestore.firestore()
        
        // read the documents at a specific path
        db.collection("wines").getDocuments { snapshot, error in
            
            // check for errror
            if error == nil {
                // no errors
                
                if let snapshot = snapshot {
                    
                    // update the list property in the main thread
                    DispatchQueue.main.async {
                        // get all the documents and create wines
                        self.list = snapshot.documents.map { doc in
                            
                            // create a wine item for each document returned
                            return Wine(id: doc.documentID,
                                        name: doc["name"] as? String ?? "",
                                        color: doc["color"] as? String ?? "",
                                        variety: doc["variety"] as? String ?? "")
                        }
                    }
                    
                }
            } else {
                // handle the error
            }
            
        }
        
    }
}
