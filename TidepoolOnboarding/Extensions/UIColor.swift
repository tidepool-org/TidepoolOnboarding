//
//  UIColor.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 5/14/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
