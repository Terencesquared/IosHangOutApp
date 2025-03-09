// MARK: - Step 4: Create FavoritesViewController
import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        
        // Set title
        title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload favorites when the view appears
        FavoritesManager.shared.loadFavorites()
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesManager.shared.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let favorite = FavoritesManager.shared.favorites[indexPath.row]
        
        // Configure cell
        var content = cell.defaultContentConfiguration()
        content.text = favorite.title
        content.secondaryText = favorite.description
        
        // Add image on the right
        if let image = UIImage(named: favorite.image) {
            content.image = image
            content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
            content.imageProperties.cornerRadius = 8
        } else {
            content.image = UIImage(systemName: "photo")
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Navigate to detailed view
        let favorite = FavoritesManager.shared.favorites[indexPath.row]
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController else {
            return
        }
        
        detailVC.itemImage = favorite.image
        detailVC.itemTitle = favorite.title
        detailVC.itemDescription = favorite.description
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from favorites
            FavoritesManager.shared.removeFavorite(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
