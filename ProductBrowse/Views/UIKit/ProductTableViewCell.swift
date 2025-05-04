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

    func configure(with product: Product, networker: any Networking) {
        productName.text = product.title
        productDescription.text = product.description
        productPrice.text = "\(product.price)€"

        productImageView.layer.cornerRadius = 16.0
        productImageView.image = UIImage(systemName: "photo.fill")

        if let imageURL = product.images.first {
            Task {
                do {
                    let image = try await networker.fetchWithCache(for: imageURL)
                        await MainActor.run {
                            self.productImageView.image = image
                        }
                    } catch {
                    print(String(describing: error))
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(systemName: "photo.fill")
        productName.text = nil
        productDescription.text = nil
        productPrice.text = nil
    }


}
