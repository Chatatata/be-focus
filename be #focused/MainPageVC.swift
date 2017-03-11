//
//  MainPageVC.swift
//  be #focused
//
//  Created by Efe Helvaci on 19.01.2017.
//  Copyright © 2017 efehelvaci. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import GameKit
import FTIndicator

class MainPageVC: UIViewController, UIPopoverPresentationControllerDelegate, GKGameCenterControllerDelegate {
    
    var treeVC : TreeVC!
    var statsVC : StatsVC!
    
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = UserDefaults.standard.integer(forKey: "treePointsScore") {
        didSet {
            UserDefaults.standard.set(score, forKey: "treePointsScore")
        }
    }
    
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var treeLeaves: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the GC authentication controller
        authenticateLocalPlayer()
        
        let firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        
        if !firstTime {
            Async.main{
                let walkVC = self.storyboard?.instantiateViewController(withIdentifier: "WalkthroughVC")
                self.present(walkVC!, animated: true, completion: nil)
            }
        }
        
        treeVC = storyboard?.instantiateViewController(withIdentifier: "TreeVC") as! TreeVC
        treeVC.modalTransitionStyle = .flipHorizontal
        treeVC.mainPage = self
        
        statsVC = storyboard?.instantiateViewController(withIdentifier: "StatsVC") as! StatsVC
        statsVC.modalPresentationStyle = .popover
        statsVC.preferredContentSize = CGSize(width: 280, height: 370)
        
        
        treeLeaves.rotate(byAngle: 4, ofType: .degrees, animated: true, duration: 1.5, completion: { _ in
            self.rotateLeaves(rotation: 1)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func startButtonClicked(_ sender: Any) {
        present(treeVC, animated: true, completion: nil)
    }
    
    @IBAction func statsButtonClicked(_ sender: Any) {
        let popoverController = statsVC.popoverPresentationController
        popoverController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverController?.delegate = self
        popoverController?.sourceView = self.view
        popoverController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        statsVC.mainPage = self
        
        present(statsVC, animated: true, completion: nil)
    }
    
    func rotateLeaves(rotation: Int) {
        if rotation == 0 {
            treeLeaves.rotate(byAngle: 8, ofType: .degrees, animated: true, duration: 3, completion: { _ in
                self.rotateLeaves(rotation: 1)
            })
            
        } else {
            treeLeaves.rotate(byAngle: -8, ofType: .degrees, animated: true, duration: 3, completion: { _ in
                self.rotateLeaves(rotation: 0)
            })
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        bannerView.isHidden = false
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error as Any)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                        
                    }
                })
                
                let gkLeaderboard = GKLeaderboard(players: [localPlayer])
                gkLeaderboard.identifier = LEADERBOARD_ID
                gkLeaderboard.timeScope = GKLeaderboardTimeScope.allTime
                
                gkLeaderboard.loadScores(completionHandler: { (scores, error) in
                    // Get current score
                    if error == nil && scores != nil {
                        if (scores?.count)! > 0 {
                            let storeScore = Int(((scores?[0])! as GKScore).value)
                            
                            if storeScore >= self.score {
                                self.score = storeScore
                            } else {
                                self.addPointsToScores(point: 0)
                            }
                        }
                    }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func scoreboardCheck(sender: UIViewController) {
        FTIndicator.showProgressWithmessage("Loading", userInteractionEnable: false)
        
        let gcVC = GKGameCenterViewController()
        
        gcVC.view.backgroundColor = UIColor.orange
         
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        
        sender.present(gcVC, animated: true, completion: {_ in
             FTIndicator.dismissProgress()
        })
    }
    
    func addPointsToScores(point: Int) {
        score = score + point
        
        if gcEnabled {
            let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
            bestScoreInt.value = Int64(score)
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
        }
    }
}
