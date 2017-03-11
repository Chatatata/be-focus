//
//  TreeVC.swift
//  be #focused
//
//  Created by Efe Helvaci on 19.01.2017.
//  Copyright © 2017 efehelvaci. All rights reserved.
//

import UIKit
import SwifterSwift
import Async
import GoogleMobileAds
import FTIndicator

class TreeVC: UIViewController {

    
    @IBOutlet var howManyPointsLabel: UILabel!
    @IBOutlet var timeSetButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var seedButton: UIButton!
    @IBOutlet var hourglassImage: UIImageView!
    @IBOutlet var informativeLabelToStart: UILabel!
    @IBOutlet var seedlingImage: UIImageView!
    @IBOutlet var treeImage: UIImageView!
    @IBOutlet var goFocusLabel: UILabel!
    @IBOutlet var cycloneImage: UIImageView!
    @IBOutlet var gameEndingMessage: UILabel!
    @IBOutlet var groundView: UIView!
    @IBOutlet var bannerView: GADBannerView!
    
    var timer : Int = 30 {
        didSet {
            firstGrowTimeInSeconds = self.timer * 45
            secondGrowTimeInSeconds = self.timer * 30
            timeInSeconds = self.timer * 60
            
            timerLabel.text = "\(timer):00"
            
            if !hourglassImage.isAnimating {
                self.hourglassImage.rotate(byAngle: 180, ofType: AngleUnit.degrees, animated: true, duration: 0.4, completion: nil)
            }
            
            switch self.timer {
            case 30:
                howManyPointsLabel.text = "+300 Tree Points"
                break
            case 45:
                howManyPointsLabel.text = "+500 Tree Points"
                break
            case 60:
                howManyPointsLabel.text = "+750 Tree Points"
                break
            case 75:
                howManyPointsLabel.text = "+1000 Tree Points"
                break
            case 90:
                howManyPointsLabel.text = "+1300 Tree Points"
                break
            case 105:
                howManyPointsLabel.text = "+1600 Tree Points"
                break
            case 120:
                howManyPointsLabel.text = "+2000 Tree Points"
                break
            default:
                break
            }
        }
    }
    var scheduledTimer : Timer!
    
    var startingTime : Date!
    
    var mainPage : MainPageVC!
    
    // Quarterway, seedling transforms into sapling
    var firstGrowTimeInSeconds = 1350
    // Halfway, seedling transforms into sapling
    var secondGrowTimeInSeconds = 900
    var timeInSeconds = 1800
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Async.main{
            let didShowIntroduction = UserDefaults.standard.bool(forKey: "didShowIntroduction")
            
            if !didShowIntroduction {
                let teacherVC = self.storyboard!.instantiateViewController(withIdentifier: "TeacherVC")
                
                self.present(teacherVC, animated: false, completion: nil)
            }
        }
        
        self.view.setNeedsLayout()
        self.view.setNeedsUpdateConstraints()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("StatusChanged"), object: nil, queue: nil, using: {(Notification) in
                if self.scheduledTimer != nil {
                    self.scheduledTimer.invalidate()
                }
            
                if UserDefaults.standard.bool(forKey: "onFocus") {
                    UserDefaults.standard.set(false, forKey: "onFocus")
                    
                    self.view.layoutIfNeeded()
                    
                    self.gameEndingMessage.text = loseMessage
                    self.gameEndingMessage.alpha = 1.0
                    self.cycloneImage.alpha = 0.0
                    self.goFocusLabel.alpha = 0.0
                    self.seedlingImage.alpha = 0.0
                    self.treeImage.image = UIImage(named: "Dead Tree")
                    self.treeImage.alpha = 1.0
                    
                    self.addPoints(positive: false)
                }
            })
        
        informativeLabelToStart.alpha = 1.0
        seedButton.alpha = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.integer(forKey: "defaultTimer") == 0 ? (timer = 30) : (timer = UserDefaults.standard.integer(forKey: "defaultTimer"))
        timerLabel.text = "\(timer):00"
        
        seedButton.isEnabled = true
        timeSetButton.isEnabled = true
        
        self.gameEndingMessage.alpha = 0.0
        self.cycloneImage.alpha = 0.0
        self.goFocusLabel.alpha = 0.0
        self.seedlingImage.alpha = 0.0
        self.treeImage.alpha = 0.0
        self.informativeLabelToStart.alpha = 1.0
        self.seedButton.alpha = 1.0
        
        if self.scheduledTimer != nil {
            self.scheduledTimer.invalidate()
        }
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        if !UserDefaults.standard.bool(forKey: "onFocus") {
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Are you sure?", message: "The tree will die if you leave now.", preferredStyle: .alert)
            let stayAction = UIAlertAction(title: "Stay", style: .default, handler: { _ in
                return
            })
            let killAction = UIAlertAction(title: "Kill", style: .destructive, handler: { _ in
                UserDefaults.standard.set(false, forKey: "onFocus")
                
                self.addPoints(positive: false)
                
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(killAction)
            alert.addAction(stayAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func timerSetButtonClicked(_ sender: Any) {
        if sender is UIButton && !(UserDefaults.standard.bool(forKey: "onFocus")){
            timer >= 120 ? (timer = 30) : (timer += 15)
            
            UserDefaults.standard.set(timer, forKey: "defaultTimer")
        }
    }
    
    @IBAction func seedClicked(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "onFocus")
        timeSetButton.isEnabled = false
        
        let seedFrame = self.seedButton.frame
        UIView.animate(withDuration: 1.0, animations: {_ in
            self.informativeLabelToStart.alpha = 0.0
            self.seedButton.frame = CGRect(origin: CGPoint(x: seedFrame.origin.x, y: seedFrame.origin.y + 100), size: seedFrame.size)
            self.seedButton.alpha = 0.0
        }, completion: {_ in
            UIView.animate(withDuration: 0.5, animations: {
                self.seedlingImage.alpha = 1.0
                self.cycloneImage.alpha = 1.0
                self.cycloneImage.rotateTimes(duration: 6, times: 3, completionDelegate: nil)
                self.goFocusLabel.alpha = 1.0
            }, completion: {_ in
                Async.main(after: 2, {
                    UIView.animate(withDuration: 1, animations: {
                        self.cycloneImage.alpha = 0.0
                        self.goFocusLabel.alpha = 0.0
                    })
                })
            })
        })
        
        if seedButton.isEnabled {
            seedButton.isEnabled = false
            
            startingTime = Date()
            
            if #available(iOS 10.0, *) {
                scheduledTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(currentTimer) in
                    self.timeTick()
                })
                
            } else {
                scheduledTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeTick), userInfo: nil, repeats: true)
            }
            
            RunLoop.current.add(scheduledTimer, forMode: .commonModes)
        }
    }
    
    func timeTick() {
        if timeInSeconds >= 0 {
            var min : String
            var sec : String
            
            
            // To keep it at least 2 digits
            (timeInSeconds / 60) < 10 ? (min = "0\(timeInSeconds / 60)") : (min = "\(timeInSeconds / 60)")
            (timeInSeconds % 60) < 10 ? (sec = "0\(timeInSeconds % 60)") : (sec = "\(timeInSeconds % 60)")
            
            self.timerLabel.text = "\(min):\(sec)"
            
            if timeInSeconds == firstGrowTimeInSeconds {
                UIView.animate(withDuration: 1, animations: {
                    self.seedlingImage.alpha = 0
                    self.treeImage.image = UIImage(named: "Sapling")
                    self.treeImage.alpha = 1.0
                })
            } else if timeInSeconds == secondGrowTimeInSeconds {
                UIView.animate(withDuration: 0.5, animations: {
                    self.treeImage.alpha = 0.0
                }, completion: {_ in
                    self.treeImage.image = UIImage(named: "Mid Tree")
                    UIView.animate(withDuration: 0.5, animations: {
                        self.treeImage.alpha = 1.0
                    })
                })
            }
            
            timeInSeconds = (timer*60) - Int(Date().timeIntervalSince(startingTime))
        } else {
            self.scheduledTimer.invalidate()
            
            self.timerLabel.text = "00:00"
            
            // Focus finished
            UserDefaults.standard.set(false, forKey: "onFocus")
            
            addPoints(positive: true)

            UIView.animate(withDuration: 0.5, animations: {
                self.seedlingImage.alpha = 0.0
                self.treeImage.alpha = 0.0
            }, completion: {_ in
                self.treeImage.image = UIImage(named: "Full Tree")
                UIView.animate(withDuration: 0.5, animations: {
                    self.treeImage.alpha = 1.0
                    self.gameEndingMessage.text = congratulationsMessage
                    self.gameEndingMessage.alpha = 1.0
                })
            })
            
        }
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        bannerView.isHidden = false
    }
    
    func addPoints(positive: Bool) {
        
        var savedPoints : Int = 0
        
        // Save the Tree Points
        switch self.timer {
        case 30:
            positive ? (savedPoints = 300) : (savedPoints = -30)
            break
        case 45:
            positive ? (savedPoints = 500) : (savedPoints = -50)
            break
        case 60:
            positive ? (savedPoints = 750) : (savedPoints = -75)
            break
        case 75:
            positive ? (savedPoints = 1000) : (savedPoints = -100)
            break
        case 90:
            positive ? (savedPoints = 1300) : (savedPoints = -130)
            break
        case 105:
            positive ? (savedPoints = 1600) : (savedPoints = -160)
            break
        case 120:
            positive ? (savedPoints = 2000) : (savedPoints = -200)
            break
        default:
            break
        }
        
        self.mainPage.addPointsToScores(point: savedPoints)
        
        // Save the tree count
        if positive {
            let treePoints = UserDefaults.standard.integer(forKey: "treeWinPoints")
            UserDefaults.standard.set(treePoints + 1, forKey: "treeWinPoints")
            FTIndicator.showNotification(with: UIImage(named: "NotificationSuccess"), title: "Awesome!", message: "You earned \(savedPoints) Tree Points!", tapHandler: {
                FTIndicator.dismissNotification()
            })
        } else {
            let treePoints = UserDefaults.standard.integer(forKey: "treeLosePoints")
            UserDefaults.standard.set(treePoints + 1, forKey: "treeLosePoints")
            
            FTIndicator.showNotification(with: UIImage(named: "NotificationFail"), title: "That was cruel!", message: "You lost \(savedPoints) Tree Points!", tapHandler: {
                FTIndicator.dismissNotification()
            })
        }
        
        
    }
}
