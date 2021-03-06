//
//  SearchTableViewCell.swift
//  SearchPdf
//
//  Created by Sikandar Ali on 14/05/2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    var section: String? = nil {
        didSet {
            sectionLabel.text = section
        }
    }
    var page: String? = nil {
        didSet {
            pageNumberLabel.text = page
        }
    }
    var resultText: String? = nil
    var searchText: String? = nil
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    @IBOutlet weak var pageNumberLabel: UILabel!
    @IBOutlet weak var resultTextLabel: UILabel!
    //    @IBOutlet private weak var sectionLabel: UILabel!
//    @IBOutlet private weak var pageNumberLabel: UILabel!
//    @IBOutlet private weak var resultTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sectionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        pageNumberLabel.textColor = .gray
        pageNumberLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        resultTextLabel.font = UIFont.preferredFont(forTextStyle: .body)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        let highlightRange = (resultText! as NSString).range(of: searchText!, options: .caseInsensitive)
        let attributedString = NSMutableAttributedString(string: resultText!)
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: resultTextLabel.font.pointSize)], range: highlightRange)
        resultTextLabel.attributedText = attributedString
    }
}
