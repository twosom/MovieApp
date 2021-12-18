//
// Created by Desire L on 2021/12/17.
//

import UIKit

class MovieCell: UITableViewCell {


    @IBOutlet
    var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .systemFont(ofSize: 24, weight: .light)
            titleLabel.textColor = .black.withAlphaComponent(0.7)
        }
    }

    @IBOutlet
    var dateLabel: UILabel! {
        didSet {
            dateLabel.font = .systemFont(ofSize: 17, weight: .ultraLight)
        }
    }
    
    @IBOutlet
    var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .systemFont(ofSize: 16, weight: .light)
        }
    }
    
    @IBOutlet
    var priceLabel: UILabel! {
        didSet {
            priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
    
    @IBOutlet
    var movieImageView: UIImageView!
    
    
}
