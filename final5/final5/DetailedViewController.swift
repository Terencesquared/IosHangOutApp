import UIKit

class DetailedViewController: UIViewController {
    
    // MARK: - Properties
    var itemImage: String?
    var itemTitle: String?
    var itemDescription: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the UI with the passed data
        configureUI()
    }
    
    @IBAction func addToFavoritesTapped(_ sender: UIButton) {
        guard let image = itemImage, let title = itemTitle, let description = itemDescription else {
            return
        }

        FavoritesManager.shared.addFavorite(image: image, title: title, description: description)
        
        // Show confirmation alert
        let alert = UIAlertController(title: "Added!", message: "This item has been added to favorites.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    // MARK: - Private Methods
    private func configureUI() {
        // Set title in navigation bar
        title = itemTitle
        
        // Set image if available
        if let imageName = itemImage, let image = UIImage(named: imageName) {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        // Set title and description
        titleLabel.text = itemTitle
        descriptionLabel.text = itemDescription
        
        // Configure description label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }
}
