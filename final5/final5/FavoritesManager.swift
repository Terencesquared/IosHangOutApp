import Foundation
class FavoritesManager {
    static let shared = FavoritesManager()
      
      private let favoritesKey = "SavedFavorites"
      
      private init() {
          loadFavorites() // Load favorites at initialization
      }
      
      // Array to store favorite items
      private(set) var favorites: [FavoriteItem] = []
      
      // Load favorites from UserDefaults
      func loadFavorites() {
          if let data = UserDefaults.standard.data(forKey: favoritesKey) {
              do {
                  favorites = try JSONDecoder().decode([FavoriteItem].self, from: data)
              } catch {
                  print("Error loading favorites: \(error)")
              }
          }
      }
      
      // Save favorites to UserDefaults
      private func saveFavorites() {
          do {
              let data = try JSONEncoder().encode(favorites)
              UserDefaults.standard.set(data, forKey: favoritesKey)
          } catch {
              print("Error saving favorites: \(error)")
          }
      }
      
      // Add a new favorite item
      func addFavorite(image: String, title: String, description: String) {
          // Check if item already exists
          if !favorites.contains(where: { $0.title == title }) {
              let newFavorite = FavoriteItem(image: image, title: title, description: description)
              favorites.append(newFavorite)
              saveFavorites()
          }
      }
      
      // Remove a favorite item
      func removeFavorite(at index: Int) {
          if index < favorites.count {
              favorites.remove(at: index)
              saveFavorites()
          }
      }
  }
