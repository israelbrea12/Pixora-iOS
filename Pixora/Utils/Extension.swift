//
//  Extension.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

extension CustomStringConvertible where Self: Any {
    
    var description: String {
        var desc: String = "*****************"
        desc += "\(type(of: self)) \n"
        let mirror = Mirror(reflecting: self)
        
        for propertyChild in mirror.children {
            if let propertyName = propertyChild.label {
                desc += "\(propertyName) : \(propertyChild.value) \n"
            }
            
        }
        
        desc += "*****************"
        return desc
    }
}
