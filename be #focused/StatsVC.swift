//
//  StatsVC.swift
//  be #focused
//
//  Created by Efe Helvaci on 29.01.2017.
//  Copyright © 2017 efehelvaci. All rights reserved.
//

import UIKit
import KDCircularProgress

class StatsVC: UIViewController {

    @IBOutlet var treePointsLabel: UILabel!
    @IBOutlet var liveTreeLabel: UILabel!
    @IBOutlet var deadTreeLabel: UILabel!
    @IBOutlet var circularView: KDCircularProgress!
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    
    let status0 = "Let's start focusing and grow your first tree!"
    let status10 = "You should try harder. Live and let live!"
    let status20 = "It's getting better! Focus on your work more!"
    let status40 = "Not bad but it could be better! Work harder!"
    let status50 = "A little bit of focusing and you will grow more trees than killing"
    let status70 = "Yay! You are getting better and better!"
    let status90 = "Fantastic! Keep up the good work!"
    let status100 = "You have some serious focusing skills! Excellent!"
    
    var mainPage : MainPageVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let treeWinPoints = UserDefaults.standard.integer(forKey: "treeWinPoints")
        let treeLosePoints = UserDefaults.standard.integer(forKey: "treeLosePoints")
        
        liveTreeLabel.text = "\(treeWinPoints)"
        deadTreeLabel.text = "\(treeLosePoints)"
        treePointsLabel.text = "\(mainPage.score) Tree Points!"
        
        let totalPoints = Double(treeWinPoints + treeLosePoints)
        
        if totalPoints != 0 {
            let percentage = Double(treeWinPoints) / totalPoints
            circularView.angle = percentage * 360
            percentageLabel.text = "%\(Int(percentage*100))"
        } else {
            circularView.angle = 0
            percentageLabel.text = "%0"
        }
        
        if totalPoints == 0 {
            resultLabel.text = status0
        } else {
            switch (Double(treeWinPoints) / totalPoints) * 100 {
            case 0...10:
                resultLabel.text = status10
                break
            case 11...20:
                resultLabel.text = status20
                break
            case 21...40:
                resultLabel.text = status40
                break
            case 41...50:
                resultLabel.text = status50
                break
            case 51...70:
                resultLabel.text = status70
                break
            case 71...90:
                resultLabel.text = status90
                break
            case 91...100:
                resultLabel.text = status100
                break
            default:
                resultLabel.text = "Live and let live!"
                break
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scoreboardButtonClicked(_ sender: Any) {
        mainPage.scoreboardCheck(sender: self)
    }

    @IBAction func coolButtonClicked(_ sender: Any) {
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
