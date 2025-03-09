import UIKit

protocol FriendAdditionDelegate: AnyObject {
    func didAddFriend(name: String)
}

class ProportionalAddFriendViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: FriendAdditionDelegate?  // Renamed to avoid conflicts
   

    
    @IBAction func addTapped(_ sender: UIButton) {
        if let name = nameTextField.text, !name.isEmpty {
            delegate?.didAddFriend(name: name)
            dismiss(animated: true)
        }
    }
}
