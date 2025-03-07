//
//  BudgetViewController 2.swift
//  final5
//
//  Created by Student3 on 07/03/2025.
//


import UIKit

class BudgetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var totalBudgetTextView: UITextView!
    
    @IBOutlet var amountSpentTextField: UITextField!
    
    
    @IBOutlet var remainingBudgetTextView: UITextView!
    
    @IBOutlet var splitBudgetButton: UIButton!
    
    
    var totalBudget: Double = 1000.0  // Default total budget
    var amountSpent: Double = 0.0  // User input

    override func viewDidLoad() {
        super.viewDidLoad()
        amountSpentTextField.delegate = self
        setupUI()
        updateBudgetLabels()
    }

    private func setupUI() {
        // Disable editing for total and remaining budget text views
        totalBudgetTextView.isEditable = false
        remainingBudgetTextView.isEditable = false
        
        // Style the button
        splitBudgetButton.layer.cornerRadius = 10
        splitBudgetButton.backgroundColor = UIColor.systemBlue
        splitBudgetButton.setTitleColor(.white, for: .normal)
        
        // Placeholder for amount spent field
        amountSpentTextField.placeholder = "Enter amount spent"
        amountSpentTextField.keyboardType = .decimalPad
    }
    
    private func updateBudgetLabels() {
        let remainingBudget = totalBudget - amountSpent
        totalBudgetTextView.text = formatCurrency(totalBudget)
        remainingBudgetTextView.text = formatCurrency(remainingBudget)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"  // Adjust for your currency
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    // Update remaining budget when user enters amount spent
    @IBAction func amountSpentChanged(_ sender: UITextField) {
        if let text = sender.text, let value = Double(text) {
            amountSpent = value
        } else {
            amountSpent = 0.0
        }
        updateBudgetLabels()
    }

   
}
