//
//  LookView.swift
//  AngelHackMoscow
//
//  Created by Alexander Danilyak on 01/07/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class LookView: UIView {
    
    var r: Double {
        let coef = (look?.items.count ?? 0) < 5 ? 2.25 : 2.75
        return Double(bounds.width) / coef
    }
    
    func imageViewSide(item: Item) -> Double {
        switch item.type {
        case .top, .bottom, .dress, .outer:
            return Double(bounds.width) * 0.50
        case .earrings, .bracelet:
            return Double(bounds.width) * 0.40
        case .shoes:
            return Double(bounds.width) * 0.30
        default:
            return Double(bounds.width) * 0.30
        }
    }
    
    var thisCenter: CGPoint {
        return CGPoint(x: bounds.width / 2.0,
                       y: bounds.height / 2.0)
    }
    
    var imageViews: [UIImageView] = []
    
    var look: Look?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addPan() {
        isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(followFinger(pan:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        addGestureRecognizer(pan)
    }
    
    // --------------------------------------------------------
    
    func set(look: Look) {
        
        self.look = look
        
        // ---
        
        _ = imageViews.map { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        gestureRecognizers?.removeAll()
        addPan()
        
        // ---
        
        let centerImageView = UIImageView(frame: CGRect(x: 0.0,
                                                        y: 0.0,
                                                        width: imageViewSide(item: look.items[0]),
                                                        height: imageViewSide(item: look.items[0])))
        
        imageViews.append(centerImageView)
        
        // ---
        
        let onCircleCount = look.items.count - 1
        let onCircleCenters = points(number: onCircleCount)
        
        for i in 0..<onCircleCount {
            let onCircleImageView = UIImageView(frame: CGRect(x: 0.0,
                                                              y: 0.0,
                                                              width: imageViewSide(item: look.items[i + 1]),
                                                              height: imageViewSide(item: look.items[i + 1])))
            
            imageViews.append(onCircleImageView)
        }
        
        // ---
        
        for i in 0..<imageViews.count {
            //imageViews[i].backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15)
            imageViews[i].contentMode = .scaleAspectFit
            imageViews[i].setImage(from: look.items[i].imageUrl)
            
            imageViews[i].center = i == 0 ? thisCenter : onCircleCenters[i-1]
            addSubview(imageViews[i])
        }
        
    }
    
    func points(number: Int) -> [CGPoint] {
        
        var points: [CGPoint] = []
        
        let _pi_2 = 90.0
        let _3pi_2 = 270.0
        
        let angles = stride(from: 0.0, to: 360.0, by: 360.0/Double(number))
        for a in angles {
            
            let ra = (a / 180.0) * Double.pi
            
            let x = r * cos(ra) + Double(thisCenter.x)
            
            let delta = a <= 180.0 ? abs(a - _pi_2) : abs(a - _3pi_2)
            let scale = max(1.0, 1.2 - 0.2 * delta / 90.0)
            
            let y = r * scale * sin(ra) + Double(thisCenter.y)

            points.append(CGPoint(x: x, y: y))
        }
        
        return points
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let tp = touches.first?.location(in: self) {
            UIView.animate(withDuration: 0.15, animations: { [unowned self] in
                for imv in self.imageViews {
                    let imvc = imv.center
                    let dist = sqrt(pow(imvc.x - tp.x, 2) + pow(imvc.y - tp.y, 2))
                    let scale = max(1 + (1 - 2 * dist / self.bounds.width), 1.0)
                    imv.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.15, animations: { [unowned self] in
            for imv in self.imageViews {
                imv.transform = CGAffineTransform.identity
            }
        })
    }
    
    // --------------------------------------------------------
    
    @objc func followFinger(pan: UIPanGestureRecognizer) {
        let tp = pan.location(in: self)
        
        if pan.state != .ended {
            for imv in imageViews {
                let imvc = imv.center
                let dist = sqrt(pow(imvc.x - tp.x, 2) + pow(imvc.y - tp.y, 2))
                let scale = max(1 + (1 - 2 * dist / bounds.width), 1.0)
                imv.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        } else {
            UIView.animate(withDuration: 0.15, animations: { [unowned self] in
                for imv in self.imageViews {
                    imv.transform = CGAffineTransform.identity
                }
            })
        }
    }
    
}
