
import UIKit

class PlannerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, EventEntryDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var calendarCollectionView: UICollectionView!

    @IBOutlet weak var monthLabel: UILabel!
        
    var daysInMonth: [String] = []
        var dayNumbers: [Int] = []
        var firstWeekday = 0
        var numberOfDaysInMonth = 0
        let calendar = Calendar.current
        var currentMonth = 0
        var currentYear = 0
    
    // Dictionary to store events (Key: "YYYY-MM-DD", Value: Event details)
        var events: [String: String] = [:]
                
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Setup collection view
            calendarCollectionView.dataSource = self
            calendarCollectionView.delegate = self
            
            // Get current date information
            let date = Date()
            currentMonth = calendar.component(.month, from: date)
            currentYear = calendar.component(.year, from: date)
            
            // Initialize calendar
            setupCalendarView()
        }
        
        func setupCalendarView() {
            dayNumbers.removeAll()
            
            var components = DateComponents()
            components.year = currentYear
            components.month = currentMonth
            components.day = 1
            
            let firstDayOfMonth = calendar.date(from: components)!
            
            firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
            if firstWeekday == 0 { firstWeekday = 7 }
            
            numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            monthLabel.text = dateFormatter.string(from: firstDayOfMonth)
            
            for _ in 1..<firstWeekday {
                dayNumbers.append(0)
            }
            
            for day in 1...numberOfDaysInMonth {
                dayNumbers.append(day)
            }
            
            calendarCollectionView.reloadData()
        }
        
        
        
        
        
        // MARK: - Navigation Controls
        
        @IBAction func previousMonth(_ sender: Any) {
            currentMonth -= 1
            if currentMonth < 1 {
                currentMonth = 12
                currentYear -= 1
            }
            setupCalendarView()
        }
        
        @IBAction func nextMonth(_ sender: Any) {
            currentMonth += 1
            if currentMonth > 12 {
                currentMonth = 1
                currentYear += 1
            }
            setupCalendarView()
        }
        
    
       
    // MARK: - Collection View Methods
      
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return dayNumbers.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
           
           let day = dayNumbers[indexPath.row]
           
           if day == 0 {
               cell.dateLabel.text = ""
           } else {
               cell.dateLabel.text = "\(day)"
           }
           
           // Set font size consistently
           cell.dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
           
           let components = DateComponents(year: currentYear, month: currentMonth, day: day)
           if let date = calendar.date(from: components) {
               let dateKey = String(format: "%04d-%02d-%02d", currentYear, currentMonth, day)
               
               if events.keys.contains(dateKey) {
                   // Day has an event
                   cell.contentView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
                   cell.dateLabel.textColor = .white
               } else if calendar.isDateInToday(date) {
                   // Today's date
                   cell.contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
                   cell.dateLabel.textColor = .white
               } else {
                   // Normal day
                   cell.contentView.backgroundColor = .clear
                   cell.dateLabel.textColor = day == 0 ? .clear : .black
               }
               
               // Make cell round for better appearance
               cell.layer.cornerRadius = cell.bounds.width / 2
               cell.clipsToBounds = true
           }
           
           return cell
       }
       
       // MARK: - UICollectionViewDelegateFlowLayout
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let width = collectionView.frame.width / 7
           let height = width // Square cells
           return CGSize(width: width, height: height)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let day = dayNumbers[indexPath.row]
           if day > 0 {
               let dateKey = String(format: "%04d-%02d-%02d", currentYear, currentMonth, day)
               
               if let eventDetails = events[dateKey] {
                   let alert = UIAlertController(title: "Event Details", message: eventDetails, preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default))
                   alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                       self.events.removeValue(forKey: dateKey)
                       self.calendarCollectionView.reloadData()
                   })
                   present(alert, animated: true)
               } else {
                   // Optionally: trigger the add event segue when tapping on a day without an event
                   performSegue(withIdentifier: "AddEventSegue", sender: dateKey)
               }
           }
       }
       
       // MARK: - Event Entry Delegate
       
       func saveEvent(date: String, details: String) {
           events[date] = details
           calendarCollectionView.reloadData()
       }
       
       // MARK: - Navigation
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "AddEventSegue",
              let destinationVC = segue.destination as? EventEntryViewController {
               destinationVC.delegate = self
               
               // If we have a specific date from tapping a day cell
               if let dateKey = sender as? String {
                   // Parse the dateKey to set the date in the event entry form
                   let parts = dateKey.split(separator: "-")
                   if parts.count == 3,
                      let year = Int(parts[0]),
                      let month = Int(parts[1]),
                      let day = Int(parts[2]) {
                       
                       let dateComponents = DateComponents(year: year, month: month, day: day)
                       if let date = calendar.date(from: dateComponents) {
                           destinationVC.selectedDate = date
                       }
                   }
               }
           }
       }
   }

   

