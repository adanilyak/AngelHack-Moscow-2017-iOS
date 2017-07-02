//
//  PageLooksController.swift
//  AngelHackMoscow
//
//  Created by Alexander Danilyak on 01/07/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class PageLooksController: UIPageViewController {
    
    var looks: [Look] = [] {
        didSet {
            looksControllers.removeAll()
            for look in looks {
                let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "lookController") as! LookController
                lvc.look = look
                looksControllers.append(lvc)
            }
        }
    }
    var looksControllers: [LookController] = []
    
    var buyButton: UIButton = {
        var b = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        b.setTitle(localize(key: "buy"), for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.heavy)
        b.backgroundColor = defaultTintColor
        b.layer.cornerRadius = 13.0
        b.addTarget(self, action: #selector(buyAlert), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([looksControllers[0]], direction: .forward, animated: true, completion: nil)
        title = String(format: localize(key: "lookWithNum"), "1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        buyButton.center = CGPoint(x: view.center.x, y: view.bounds.height - 60)
        view.addSubview(buyButton)
    }
    
    @objc func buyAlert() {
        let vc = UIAlertController(title: localize(key: "buySuccess"),
                                   message: localize(key: "buyDescription"),
                                   preferredStyle: .alert)
        let ok = UIAlertAction(title: localize(key: "errorOk"), style: .cancel, handler: nil)
        vc.view.tintColor = defaultTintColor
        vc.addAction(ok)
        present(vc, animated: true, completion: nil)
    }
}

extension PageLooksController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let lvc = viewController as? LookController,
            let index = looksControllers.index(of: lvc),
            index != 0 {
            return looksControllers[index - 1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let lvc = viewController as? LookController,
            let index = looksControllers.index(of: lvc),
            index != looksControllers.count - 1 {
            return looksControllers[index + 1]
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return looksControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

extension PageLooksController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let vc = viewControllers?.first as? LookController,
                let index = looksControllers.index(of: vc) {
                title = String(format: localize(key: "lookWithNum"), "\(index + 1)")
            }
        }
    }
    
}
