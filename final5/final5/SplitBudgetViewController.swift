
import UIKit

class SplitBudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddFriendDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchProportional: UISwitch!

    var people: [String] = ["Person 1", "Person 2"] // Default entries
        var amounts: [Double] = [0.0, 0.0] // Budget share per person
        let totalBudget: Double = 1000.0 // Assume this comes from BudgetViewController

        override func viewDidLoad() {
            super.viewDidLoad()
            switchProportional.isOn = false
            tableView.delegate = self
            tableView.dataSource = self
        }

        // Prepare for segue when "Add Friend" button is tapped
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "AddFriendSegue",
               let addFriendVC = segue.destination as? AddFriendViewController {
                addFriendVC.delegate = self // Assign delegate
            }
        }

        // Delegate method to receive data from AddFriendViewController
        func didAddFriend(name: String, amount: Double) {
            people.append(name)
            amounts.append(amount)
            tableView.reloadData()
        }


    @IBAction func splitTapped(_ sender: UIButton) {
        if switchProportional.isOn {
            proportionalSplit()
        } else {
            equalSplit()
        }
        tableView.reloadData()
    }

    func proportionalSplit() {
            let totalPeople = Double(people.count)
            for i in 0..<amounts.count {
                amounts[i] = totalBudget / totalPeople
            }
        }

        func equalSplit() {
            let equalAmount = totalBudget / Double(people.count)
            amounts = Array(repeating: equalAmount, count: people.count)
        }

        // MARK: - TableView Methods

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return people.count + 2 // Extra 2 rows for Total Cost & Amount Left
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row < people.count {
                // Regular person row
                let cell = tableView.dequeueReusableCell(withIdentifier: "SplitCell", for: indexPath)
                cell.textLabel?.text = "\(people[indexPath.row]) - Ksh\(amounts[indexPath.row])"
                return cell
            } else if indexPath.row == people.count {
                // Total Cost row
                let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCostCell", for: indexPath)
                let totalContributed = amounts.reduce(0, +)
                cell.textLabel?.text = "Total Cost: Ksh\(totalContributed)"
                return cell
            } else {
                // Amount Left row
                let cell = tableView.dequeueReusableCell(withIdentifier: "AmountLeftCell", for: indexPath)
                let totalContributed = amounts.reduce(0, +)
                let amountLeft = totalBudget - totalContributed
                cell.textLabel?.text = "Amount Left: Ksh\(amountLeft)"
                return cell
            }
        }
}
