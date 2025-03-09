import UIKit


    
    // Calendar Cell Class
    class CalendarCell: UICollectionViewCell {
        
            @IBOutlet weak var dateLabel: UILabel!
        override func awakeFromNib() {
               super.awakeFromNib()
               dateLabel.textAlignment = .center
           }

           override func prepareForReuse() {
               super.prepareForReuse()
               contentView.backgroundColor = .clear
               dateLabel.textColor = .white
           }
            
        }
