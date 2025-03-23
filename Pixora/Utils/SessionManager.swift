//
//  SessionManager.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Firebase
import FirebaseAuth
import FirebaseStorage

@MainActor
class SessionManager: NSObject, ObservableObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = SessionManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        
        super.init()
        
    }
}
