//
//  ViewController.swift
//  final5
//
//  Created by Student3 on 05/03/2025.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
  
    @IBOutlet var discoverDailyCollectionView: UICollectionView!
    @IBOutlet var trendingOffersCollectionView: UICollectionView!
    
    // Add search bar
           private let searchBar = UISearchBar()
           private var filteredItems: [(image: String, title: String, description: String)] = []
           private var isSearching = false
           private var searchTableView: UITableView!
           
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
               
               // Set up search bar
               setupSearchBar()
               
               // Set up search results table view
               setupSearchTableView()
               
               // Set Delegates & Data Sources
               discoverDailyCollectionView.delegate = self
               discoverDailyCollectionView.dataSource = self
               trendingOffersCollectionView.delegate = self
               trendingOffersCollectionView.dataSource = self
           }
           
           private func setupSearchBar() {
               searchBar.delegate = self
               searchBar.placeholder = "Search for locations..."
               searchBar.searchBarStyle = .minimal
               
               // Add search bar to navigation item if using navigation controller
               if let navigationController = navigationController {
                   navigationItem.titleView = searchBar
               } else {
                   // Otherwise add it to the view
                   searchBar.translatesAutoresizingMaskIntoConstraints = false
                   view.addSubview(searchBar)
                   
                   NSLayoutConstraint.activate([
                       searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                       searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                       searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                   ])
               }
           }
           
    private func setupSearchTableView() {
        searchTableView = UITableView()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        searchTableView.isHidden = true
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTableView)
        
        // Fix: Don't constrain directly to searchBar.bottomAnchor
        // Instead, calculate position based on searchBar's frame or use topAnchor with constant
        let searchBarHeight = searchBar.frame.origin.y + searchBar.frame.height
        
        NSLayoutConstraint.activate([
            // Use view's top anchor with an offset instead
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchBarHeight),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
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
           
           // Collection View Delegate - handle taps on collection view items
           func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
               if collectionView == discoverDailyCollectionView {
                   let selectedItem = discoverDailyItems[indexPath.item]
                   navigateToDetailView(for: selectedItem)
               }
               // You can handle taps on trending offers similarly if needed
           }
           
           // MARK: - Collection View Flow Layout
           func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               if collectionView == discoverDailyCollectionView {
                   return CGSize(width: collectionView.frame.width * 0.7, height: 150)
               } else {
                   return CGSize(width: collectionView.frame.width, height: 200)
               }
           }
           
           // MARK: - Search Bar Delegate Methods
           func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
               isSearching = true
               searchTableView.isHidden = false
           }
           
           func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
               isSearching = false
               searchTableView.isHidden = true
           }
           
           func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
               isSearching = false
               searchBar.text = ""
               searchTableView.isHidden = true
               searchBar.resignFirstResponder()
           }
           
           func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
               if searchText.isEmpty {
                   filteredItems = []
                   searchTableView.isHidden = true
               } else {
                   filterContentForSearchText(searchText)
                   searchTableView.isHidden = false
               }
               searchTableView.reloadData()
           }
           
           private func filterContentForSearchText(_ searchText: String) {
               filteredItems = discoverDailyItems.filter { item in
                   return item.title.lowercased().contains(searchText.lowercased()) ||
                          item.description.lowercased().contains(searchText.lowercased())
               }
           }
           
           // MARK: - Navigation to Detail
           private func navigateToDetailView(for item: (image: String, title: String, description: String)) {
               // Get storyboard and instantiate DetailViewController
               guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController else {
                   print("Failed to instantiate DetailViewController")
                   return
               }
               
               // Configure DetailViewController with selected item data
               detailVC.itemImage = item.image
               detailVC.itemTitle = item.title
               detailVC.itemDescription = item.description
               
               // Push DetailViewController
               navigationController?.pushViewController(detailVC, animated: true)
           }
       }

// MARK: - UITableViewDelegate, UITableViewDataSource for Search Results
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let item = filteredItems[indexPath.row]
        
        // Configure cell
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.description
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = filteredItems[indexPath.row]
        
        // Get storyboard and instantiate DetailViewController
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController else {
            print("Failed to instantiate DetailedViewController")
            return
        }
        
        // Configure DetailViewController with selected item data
        detailVC.itemImage = selectedItem.image
        detailVC.itemTitle = selectedItem.title
        detailVC.itemDescription = selectedItem.description
        
        // Push DetailViewController
        navigationController?.pushViewController(detailVC, animated: true)
        
        // Close search
        searchBar.resignFirstResponder()
        searchTableView.isHidden = true
    }
}
