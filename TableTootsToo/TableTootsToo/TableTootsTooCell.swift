//
//  TableTootsTooCell.swift
//  TableTootsToo
//
//  Created by Conor on 2018-03-05.
//  Copyright © 2018 Conor. All rights reserved.
//

import Foundation
import UIKit

class TableTootsTooCell: UITableViewCell { //Cells like this, in my opinion should be stupid and not do any real work other than displaying what you give them
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    func setDataModel(model: CellViewModel) {
        titleLabel.text = model.title
        if let urlString = model.imageURLString {
            mainImageView.setImageWithURLString(urlString: urlString)
        }
    }
}
