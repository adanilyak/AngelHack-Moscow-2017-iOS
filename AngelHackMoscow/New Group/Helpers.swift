//
//  Helpers.swift
//  AngelHackMoscow
//
//  Created by Alexander Danilyak on 01/07/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

func localize(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

extension UIImageView {
    public func setImage(from url: URL) {
        Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else {
                return
            }
            
            UIView.transition(with: self,
                              duration: 0.2,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.image = image
            },
                              completion: nil)
        }
    }
}

let defaultTintColor = UIColor(red: 170.0/255.0,
                               green: 0.0/255.0,
                               blue: 25.0/255.0,
                               alpha: 1.0)

let lightTintColor = UIColor(red: 170.0/255.0,
                               green: 0.0/255.0,
                               blue: 25.0/255.0,
                               alpha: 0.5)

func setNavBarAppearance() {
    let navAppearance = UINavigationBar.appearance()
    navAppearance.tintColor = defaultTintColor
    navAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black,
                                         NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.heavy)]
}

func setPageControllApperance() {
    let pageApperance = UIPageControl.appearance()
    pageApperance.currentPageIndicatorTintColor = defaultTintColor
    pageApperance.pageIndicatorTintColor = lightTintColor
    pageApperance.backgroundColor = UIColor.white
}

func correctlyOrientedImage(image: UIImage) -> UIImage {
    if image.imageOrientation == UIImageOrientation.up {
        return image
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    image.draw(in: CGRect(x: 0,y: 0, width: image.size.width, height: image.size.height))
    let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}
