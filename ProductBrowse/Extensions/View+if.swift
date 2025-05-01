//
//  View+if.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 01/05/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
