//
//  RedactedShimmer.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 01/05/2025.
//

import SwiftUI

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, Color.white.opacity(0.4), .clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 350
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(Shimmer())
    }
}

