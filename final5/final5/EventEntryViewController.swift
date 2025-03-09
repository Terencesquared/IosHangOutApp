import UIKit

protocol EventEntryDelegate: AnyObject {
    func saveEvent(date: String, details: String)
}

class EventEntryViewController: UIViewController {

    @IBOutlet weak var restaurantTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!

    weak var delegate: EventEntryDelegate?
        var selectedDate: Date?
        
        // We need to format the date string for the key in the events dictionary
        private func formatDateKey() -> String? {
            guard let date = selectedDate else { return nil }
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            return String(format: "%04d-%02d-%02d", year, month, day)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // If we have a selected date, populate the date field
            if let date = selectedDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateTextField.text = dateFormatter.string(from: date)
            }
            
            // Set up date picker for the date field
            setupDatePicker()
        }
        
        func setupDatePicker() {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
            
            // Set the date picker to the selected date if available
            if let date = selectedDate {
                datePicker.date = date
            }
            
            dateTextField.inputView = datePicker
            
            // Add done button to keyboard toolbar
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([flexSpace, doneButton], animated: true)
            dateTextField.inputAccessoryView = toolbar
        }
        
        @objc func dateChanged(sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateTextField.text = dateFormatter.string(from: sender.date)
            selectedDate = sender.date
        }
        
        @objc func donePressed() {
            view.endEditing(true)
        }
    @IBAction func saveEvent(_ sender: UIButton) {
        guard let restaurant = restaurantTextField.text, !restaurant.isEmpty,
              let location = locationTextField.text, !location.isEmpty,
              let date = dateTextField.text, !date.isEmpty,
              let time = timeTextField.text, !time.isEmpty,
              let budget = budgetTextField.text, !budget.isEmpty else {
            showAlert(message: "Please fill in all fields")
            return
        }

        guard let dateKey = formatDateKey() else {
                  showAlert(message: "Invalid date selected")
                  return
              }
              
              let eventDetails = "Restaurant: \(restaurant)\nLocation: \(location)\nTime: \(time)\nBudget: \(budget)"
              delegate?.saveEvent(date: dateKey, details: eventDetails)
              
              dismiss(animated: true)
          }
          
          func showAlert(message: String) {
              let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default))
              present(alert, animated: true)
          }
}
