//
//  ViewController.swift
//  final5
//
//  Created by Student3 on 05/03/2025.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
  
    @IBOutlet var discoverDailyCollectionView: UICollectionView!
    @IBOutlet var trendingOffersCollectionView: UICollectionView!
    
    // Sample Data for Discover Daily
    let discoverDailyItems: [(image: String, title: String, description: String)] = [
        ("image1", "Explore Nature", "Discover hidden gems in the wild."),
        ("image2", "Urban Vibes", "Find the best city spots."),
        ("image3", "Foodie Heaven", "Try new restaurants and cuisines.")
    ]
    
    // Sample Data for Trending Offers
    let trendingOffersItems: [String] = ["offer1", "offer2", "offer3", "offer4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cells
     
        

        // Set Delegates & Data Sources
        discoverDailyCollectionView.delegate = self
        discoverDailyCollectionView.dataSource = self
        trendingOffersCollectionView.delegate = self
        trendingOffersCollectionView.dataSource = self
    }
    
    // MARK: - Collection View DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == discoverDailyCollectionView {
            return discoverDailyItems.count
        } else {
            return trendingOffersItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == discoverDailyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverDailyCell", for: indexPath) as! DiscoverDailyCell
            let item = discoverDailyItems[indexPath.item]
            cell.descriptionLabel.numberOfLines = 0
            cell.descriptionLabel.lineBreakMode = .byWordWrapping
            cell.imageView.image = UIImage(named: item.image)
            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.description
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingOffersCell", for: indexPath) as! TrendingOffersCell
            let imageName = trendingOffersItems[indexPath.item]
            cell.imageView.image = UIImage(named: imageName)
            return cell
        }
    }
    
    // MARK: - Collection View Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == discoverDailyCollectionView {
            return CGSize(width: collectionView.frame.width * 0.7, height: 150)
        } else {
            return CGSize(width: collectionView.frame.width, height: 200)
        }
    }
}


