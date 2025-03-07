import UIKit

class ProportionalSplitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func splitTapped(_ sender: UIButton) {
        guard let totalAmountText = amountTextField.text, let totalAmount = Double(totalAmountText), !friends.isEmpty else {
            return
        }
        
        let perPersonAmount = totalAmount / Double(friends.count)
        
        let message = friends.map { "\($0) - \(String(format: "%.2f", perPersonAmount)) Ksh" }.joined(separator: "\n")
        
        let alert = UIAlertController(title: "Split Amounts", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        cell.textLabel?.text = friends[indexPath.row]
        return cell
    }
}

// MARK: - Delegate to Receive Friend's Name
protocol FriendAdditionDelegate: AnyObject {
    func didAddFriend(name: String)
}

extension ProportionalSplitViewController: FriendAdditionDelegate {
    func didAddFriend(name: String) {
        friends.append(name)
        tableView.reloadData()
    }
}
