//
//  WalkthroughContentVC.swift
//  be #focused
//
//  Created by Efe Helvaci on 30.01.2017.
//  Copyright © 2017 efehelvaci. All rights reserved.
//

import UIKit

class WalkthroughContentVC: UIViewController {
    
    @IBOutlet var slideImage: UIImageView!
    
    @IBOutlet var slideLabel: UILabel!
    
    @IBOutlet var skipButton: UIButton!
    
    @IBOutlet var gotItbutton: UIButton!
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var colorBackground: UIView!
    
    var index = 0
    var imageName = ""
    var text = ""
    var backgroundColor : UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsLayout()
        self.view.setNeedsUpdateConstraints()
        
        slideImage.image = UIImage(named: imageName)
        slideLabel.text = text
        colorBackground.backgroundColor = backgroundColor
        
        if index != 2 {
            skipButton.isHidden = false
            gotItbutton.isHidden = true
        } else {
            skipButton.isHidden = true
            gotItbutton.isHidden = false
        }
        
        pageControl.currentPage = index
        
        skipButton.addTarget(self, action: #selector(dismissing), for: .touchUpInside)
        gotItbutton.addTarget(self, action: #selector(dismissing), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissing() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "firstTime")
        
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
