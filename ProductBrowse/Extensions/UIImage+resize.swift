//
//  UIImage+resize.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 05/05/2025.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
