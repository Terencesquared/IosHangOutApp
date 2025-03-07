//
//  AddFriendViewController.swift
//  final5
//
//  Created by Student3 on 07/03/2025.
//

import Foundation
protocol AddFriendDelegate: AnyObject {
    func didAddFriend(name: String, amount: Double)
}
import UIKit

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    weak var delegate: AddFriendDelegate? // Delegate reference
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        print("Button pressed")
        guard let name = nameTextField.text, !name.isEmpty,
                      let amountText = amountTextField.text, let amount = Double(amountText)
        else {
                    return
        }
        
        delegate?.didAddFriend(name: name, amount: amount)
        dismiss(animated: true, completion: nil) // Go back to main screen
    }
}
