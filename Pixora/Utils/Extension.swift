//
//  Extension.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation
import UIKit
import SwiftUI

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

extension String {
    var initials: String {
        return self
            .components(separatedBy: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()
    }
}

struct IdentifiableImage: Identifiable, Equatable {
    let id = UUID()
    let image: UIImage

    static func == (lhs: IdentifiableImage, rhs: IdentifiableImage) -> Bool {
        lhs.id == rhs.id
    }
}

extension Notification.Name {
    static let navigateToMyPhotos = Notification.Name("navigateToMyPhotos")
}

extension View {
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension UIDevice {
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}

extension LinearGradient {
    static let mainBluePurple = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension View {
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> TrueContent,
        @ViewBuilder else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
}




