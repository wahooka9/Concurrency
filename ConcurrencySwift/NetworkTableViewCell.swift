//
//  NetworkTableViewCell.swift
//  ConcurrencySwift
//
//  Created by Andrew Riznyk on 9/27/17.
//  Copyright © 2017 Andrew Riznyk. All rights reserved.
//

import UIKit

class NetworkTableViewCell: UITableViewCell {

    @IBOutlet weak var networkImage: UIImageView!
    @IBOutlet weak var indexLabelOutlet: UILabel!
    @IBOutlet weak var informationLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


