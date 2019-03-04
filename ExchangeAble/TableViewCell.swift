//
//  TableViewCell.swift
//  ExchangeAble
//
//  Created by Antonius George on 27/09/18.
//  Copyright © 2018 Atn010. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	@IBOutlet weak var Currency: UILabel!
	@IBOutlet weak var Rate: UILabel!
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
