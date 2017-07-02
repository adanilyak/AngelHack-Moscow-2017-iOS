//
//  LookController.swift
//  AngelHackMoscow
//
//  Created by Alexander Danilyak on 01/07/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class LookController: UIViewController {
    
    var look: Look?
    var lookView: LookView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lookView = LookView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: UIScreen.main.bounds.width + 70))
        
        if let l = look,
            let lv = lookView {
            lv.center = CGPoint(x: view.center.x, y: view.center.y - 45)
            view.addSubview(lv)
            lv.set(look: l)
            
            //registerForPreviewing(with: self, sourceView: lv)
        }
        
    }
}

extension LookController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let v = previewingContext.sourceView
        previewingContext.sourceRect = CGRect(origin: CGPoint(x: v.frame.origin.x - v.bounds.width/2,
                                                              y: v.frame.origin.y - v.bounds.height/2),
                                              size: CGSize(width: v.bounds.width,
                                                           height: v.bounds.height))
        return UIViewController()
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        //
    }
    
}
