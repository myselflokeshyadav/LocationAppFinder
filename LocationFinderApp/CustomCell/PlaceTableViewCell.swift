//
//  PlaceTableViewCell.swift
//  LocationFinderApp
//
//  Created by Atul Bhaisare  on 21/05/19.
//  Copyright © 2019 Atul Bhaisare. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescrpition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
