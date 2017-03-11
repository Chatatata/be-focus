//
//  WalkthroughVC.swift
//  be #focused
//
//  Created by Efe Helvaci on 30.01.2017.
//  Copyright © 2017 efehelvaci. All rights reserved.
//

import UIKit

class WalkthroughVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageDescription = ["Oh hello there! Welcome to the perfect place for focusing :) Grow a tree while doing it!",
                           "It's very important to focus on your jobs while working! ",
                           "Don't forget that you can not do any other thing with your phone while growing a tree. Don't let the cuties die :)"]
    var pageImages = ["Tree1", "Developer1", "Cupcake1"]
    var pageColors = [ UIColor(red: 200/255.0, green: 96/255.0, blue: 3/255.0, alpha: 1),
                       UIColor(red: 46/255.0, green: 134/255.0, blue: 171/255.0, alpha: 1),
                       UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let startVC = self.viewControllerAtIndex(index: 0) {
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentVC).index
        index += 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentVC).index
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    func nextPageWithIndex(index: Int) {
        
    }
    
    func viewControllerAtIndex(index: Int) -> WalkthroughContentVC? {
        if index == NSNotFound || index < 0 || index >= pageDescription.count {
            return nil
        }
        
        let walkthroughVC = WalkthroughContentVC(nibName: "WalkthroughContentVC", bundle: nil)
        walkthroughVC.index = index
        walkthroughVC.imageName = pageImages[index]
        walkthroughVC.text = pageDescription[index]
        walkthroughVC.backgroundColor = pageColors[index]
        
        return walkthroughVC
    }
}
