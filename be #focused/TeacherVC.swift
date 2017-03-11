//
//  TeacherVC.swift
//  be #focused
//
//  Created by Efe Helvaci on 08/02/2017.
//  Copyright © 2017 efehelvaci. All rights reserved.
//

import UIKit

class TeacherVC: UIViewController {

    @IBOutlet var timer: UIButton!
    @IBOutlet var hourglass: UIImageView!
    @IBOutlet var arrow: UIImageView!
    @IBOutlet var informativeLabel: UILabel!
    @IBOutlet var informativeLabel1: UILabel!
    @IBOutlet var informativeLabel2: UILabel!
    @IBOutlet var seed: UIImageView!
    @IBOutlet var button: UIButton!
    @IBOutlet var subview: UIView!
    @IBOutlet var arrowTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()



        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.arrow.frame = CGRect(x: self.arrow.frame.origin.x, y: self.arrow.frame.origin.y+50, width: self.arrow.frame.size.width, height: self.arrow.frame.size.height)
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if button.titleLabel!.text! == "Next" {
            button.setTitle("Let's do it!", for: .normal)
            
            timer.alpha = 0
            hourglass.alpha = 0
            arrow.alpha = 0
            informativeLabel.alpha = 0
            informativeLabel1.alpha = 1.0
            informativeLabel2.alpha = 1.0
            seed.alpha = 1.0
        } else {
            UserDefaults.standard.set(true, forKey: "didShowIntroduction")
            
            dismiss(animated: false, completion: nil)
        }
    }
}
