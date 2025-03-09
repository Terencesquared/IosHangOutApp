import UIKit

class ProportionalSplitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendAdditionDelegate{

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
    // ✅ Set the delegate before the segue occurs
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let addFriendVC = segue.destination as? ProportionalAddFriendViewController {
               addFriendVC.delegate = self  // ✅ Now the delegate is properly set
           }
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
    func didAddFriend(name: String) {
           friends.append(name)
           tableView.reloadData()
       }
}

// MARK: - Delegate to Receive Friend's Name




