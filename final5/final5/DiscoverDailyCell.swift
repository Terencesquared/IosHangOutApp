//
//  DiscoverDailyCell.swift
//  final5
//
//  Created by Student3 on 06/03/2025.
//


//

import Foundation

import UIKit
class DiscoverDailyCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            setupConstraints()
        }
        
    private func setupUI() {
           // Apply rounded corners to the image
           imageView.layer.cornerRadius = 15
           imageView.clipsToBounds = true
       }
       
       private func setupConstraints() {
           // Disable autoresizing masks to use Auto Layout
           imageView.translatesAutoresizingMaskIntoConstraints = false
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               // ImageView Constraints - Increased Size
               imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
               imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9), // 90% of the cell width
               imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.8), // 80% of width for good proportions
               
               // Title Label Constraints
               titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
               titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
               titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
               titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),

               // Description Label Constraints
               descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
               descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
               descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
               descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
           ])
       }

    }

