//
//  UIImage+ImageFromURL.swift
//  TableTootsToo
//
//  Created by Conor on 2018-03-14.
//  Copyright © 2018 Conor. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView { //An Extension lets you add new functionality to an existing class, even ones you didn't write!

    func setImageWithURLString(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        do {
            let data = try Data(contentsOf:url)
            self.image = UIImage(data: data)
        }
        catch {
            return
        }
    }
}

