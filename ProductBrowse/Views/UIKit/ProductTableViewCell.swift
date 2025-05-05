//
//  ProductTableViewCell.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 04/05/2025.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addedToFavoritesOverlayView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.contentMode = .scaleAspectFit
        productName.font = .systemFont(ofSize: 16)
        productDescription.font = .systemFont(ofSize: 14)
        productPrice.font = .boldSystemFont(ofSize: 16)
        productDescription.textColor = .gray
        productDescription.numberOfLines = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with product: Product, networker: any Networking, completion: @escaping (() -> Bool)) {
        productName.text = product.title
        productDescription.text = product.description
        productPrice.text = "\(product.price)€"

        productImageView.layer.cornerRadius = 16.0
        productImageView.image = UIImage(systemName: "photo.fill")
        addedToFavoritesOverlayView.alpha = 0.0

        if let imageURL = product.images.first {
            Task {
                do {
                    let image = try await networker.fetchWithCache(for: imageURL)
                    await MainActor.run {
                        self.productImageView.image = image
                        if completion() {
                            configureOverlay()
                        }
                    }
                } catch {
                    print(String(describing: error))
                }
            }
        }
    }

    private func configureOverlay() {
        addedToFavoritesOverlayView.layer.cornerRadius = 16.0
        let addedToFavoritesImageView = UIImageView()
        addedToFavoritesImageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        addedToFavoritesImageView.contentMode = .scaleAspectFill
        addedToFavoritesImageView.image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        addedToFavoritesOverlayView.addSubview(addedToFavoritesImageView)

        addedToFavoritesImageView.center = CGPoint(x: addedToFavoritesOverlayView.bounds.midX, y: addedToFavoritesOverlayView.bounds.midY)

        addedToFavoritesOverlayView.alpha = 0.5

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(systemName: "photo.fill")
        productName.text = nil
        productDescription.text = nil
        productPrice.text = nil
    }
}
