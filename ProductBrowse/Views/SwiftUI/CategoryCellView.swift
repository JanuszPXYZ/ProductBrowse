//
//  CategoryCellView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 01/05/2025.
//

import SwiftUI

struct CategoryCellView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16.0)
            .frame(width: 140, height: 140)
            .foregroundStyle(.gray)
            .overlay {
                ZStack {
                    Capsule()
                        .foregroundStyle(.white)
                        .frame(width: 80, height: 15)
                    Text("Category")
                        .foregroundStyle(.black)
                        .font(.caption2)
                        .fontWeight(.bold)
                }
                .offset(x: 20, y: 50)
            }
    }
}

#Preview {
    CategoryCellView()
}
