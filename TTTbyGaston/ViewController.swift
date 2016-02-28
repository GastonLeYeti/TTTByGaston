//
//  ViewController.swift
//  TTTbyGaston
//
//  Created by Gaëtan PECQUEUX on 18/02/2016.
//  Copyright © 2016 Gaëtan PECQUEUX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var TTTImg1: UIImageView!
    @IBOutlet var TTTImg2: UIImageView!
    @IBOutlet var TTTImg3: UIImageView!
    @IBOutlet var TTTImg4: UIImageView!
    @IBOutlet var TTTImg5: UIImageView!
    @IBOutlet var TTTImg6: UIImageView!
    @IBOutlet var TTTImg7: UIImageView!
    @IBOutlet var TTTImg8: UIImageView!
    @IBOutlet var TTTImg9: UIImageView!
    
    @IBOutlet var TTTBtn1: UIButton!
    @IBOutlet var TTTBtn2: UIButton!
    @IBOutlet var TTTBtn3: UIButton!
    @IBOutlet var TTTBtn4: UIButton!
    @IBOutlet var TTTBtn5: UIButton!
    @IBOutlet var TTTBtn6: UIButton!
    @IBOutlet var TTTBtn7: UIButton!
    @IBOutlet var TTTBtn8: UIButton!
    @IBOutlet var TTTBtn9: UIButton!
    
    @IBOutlet var TTTBtnRestart: UIButton!
    
    @IBOutlet var TTTLabel: UILabel!
    
    
    var play = Dictionary<Int,Int>()
    var finish = false
    var IA = false
    
    @IBAction func UIButtonClicked(sender:UIButton){
        TTTLabel.hidden = true
        if play[sender.tag]==nil && !IA && !finish {
            SetImageForSpot(sender.tag, joueur:1)
        }
        
        CheckVictoire()
        SecondJoueur()
    }
    
    func SetImageForSpot(spot:Int,joueur:Int) {
        let mark = joueur == 1 ? "X" : "O"
        play[spot] = joueur
        
        switch spot{
        case 1:
            TTTImg1.image = UIImage(named: mark)
        case 2:
            TTTImg2.image = UIImage(named: mark)
        case 3:
            TTTImg3.image = UIImage(named: mark)
        case 4:
            TTTImg4.image = UIImage(named: mark)
        case 5:
            TTTImg5.image = UIImage(named: mark)
        case 6:
            TTTImg6.image = UIImage(named: mark)
        case 7:
            TTTImg7.image = UIImage(named: mark)
        case 8:
            TTTImg8.image = UIImage(named: mark)
        case 9:
            TTTImg9.image = UIImage(named: mark)
        default:
            TTTImg1.image = UIImage(named: mark)
        }
        
    }
    
    @IBAction func ClickToRecommencer(sender:UIButton){
        finish = false
        TTTBtnRestart.hidden = true
        TTTLabel.hidden = true
        recommencer()
    }
    
    func recommencer(){
        play = [:]
        TTTImg1.image = nil
        TTTImg2.image = nil
        TTTImg3.image = nil
        TTTImg4.image = nil
        TTTImg5.image = nil
        TTTImg6.image = nil
        TTTImg7.image = nil
        TTTImg8.image = nil
        TTTImg9.image = nil
    }
    
    func CheckVictoire(){
        let QGagne = ["joueur 1":1, "joueur 2":0]
        for(key,value) in QGagne {
            if(
                (play[1] == value && play[2] == value && play[3] == value) || // H Haute
                    (play[4] == value && play[5] == value && play[6] == value) || // H Midd
                    (play[7] == value && play[8] == value && play[9] == value) || // H Bas
                    (play[1] == value && play[4] == value && play[7] == value) || // V Gauche
                    (play[2] == value && play[5] == value && play[8] == value) || // V Midd
                    (play[3] == value && play[6] == value && play[9] == value) || // V Droite
                    (play[1] == value && play[5] == value && play[9] == value) || // Daig GtoD
                    (play[3] == value && play[5] == value && play[7] == value)    // Diag DtoG
                ){
                    TTTLabel.hidden = false
                    TTTLabel.text = "\(key) gagne la partie !!"
                    TTTBtnRestart.hidden = false
                    finish = true
            }
        }
    }
    
    
    func checkT(value value:Int) -> (location:String,pattern:String){
        return ("Top", checkFor(value, inList: [1,2,3]))
    }
    func checkM(value value:Int) -> (location:String,pattern:String){
        return ("Middle", checkFor(value, inList: [4,5,6]))
    }
    func checkB(value value:Int) -> (location:String,pattern:String){
        return ("Bottom", checkFor(value, inList: [7,8,9]))
    }
    func checkG(value value:Int) -> (location:String,pattern:String){
        return ("Gauche", checkFor(value, inList: [1,4,7]))
    }
    func checkMM(value value:Int) -> (location:String,pattern:String){
        return ("VMiddle", checkFor(value, inList: [2,5,8]))
    }
    func checkD(value value:Int) -> (location:String,pattern:String){
        return ("Droite", checkFor(value, inList: [3,6,9]))
    }
    func checkDGD(value value:Int) -> (location:String,pattern:String){
        return ("DiagGaucheDroite", checkFor(value, inList: [1,5,9]))
    }
    func checkDDG(value value:Int) -> (location:String,pattern:String){
        return ("DiagDroiteGauche", checkFor(value, inList: [3,5,7]))
    }
    
    func checkFor(value:Int, inList:[Int]) -> String {
        var conclusion = ""
        for cell in inList {
            if play[cell] == value {
                conclusion += "1"
            }
            else{
                conclusion += "0"
            }
        }
        return conclusion
    }
    
    func rowCheck(value value:Int) -> (location:String,pattern:String)? {
        let Possible = ["011","101","110"]
        let Trouve = [checkT,checkM,checkD,checkG,checkMM,checkD,checkDGD,checkDDG]
        for algo in Trouve {
            let algorResult = algo(value:value)
            if find(Possible,algorResult.pattern) {
                return algorResult
            }
        }
        return nil
    }
    
    
    func occup(spot:Int) -> Bool {
        return Bool(play[spot])
    }
    
    func SecondJoueur(){
        if finish {
            return
        }
        IA = true
        
        // IA
        if let result = rowCheck(value:0){
            var ouJouerResult = ouJouer(result.location, pattern:result.pattern)
            if !occup(ouJouerResult){
                SetImageForSpot(ouJouerResult, joueur: 0)
                IA = false
                CheckVictoire()
                
            }
        }
        // Joueur
        if let result = rowCheck(value:1){
            var ouJouerResult = ouJouer(result.location, pattern:result.pattern)
            if !occup(ouJouerResult){
                SetImageForSpot(ouJouerResult, joueur: 0)
                IA = false
                CheckVictoire()
                
            }
        }
        
        func premierPri(coin coin:Bool) -> Int? {
            let Spots = coin ? [1,3,7,9] : [2,4,6,8]
            for spot in Spots {
                if !occup(spot){
                    return spot
                }
            }
            return nil
        }
        
        //coin 
        if let coinPris = premierPri(coin:true) {
            SetImageForSpot(coinPris, joueur: 0)
            IA = false
            CheckVictoire()
            return
        }
        
        //millieu
        if let millieuPris = premierPri(coin:false) {
            SetImageForSpot(millieuPris, joueur: 0)
            IA = false
            CheckVictoire()
            return
        }
        
        //centre
        if !occup(5){
            SetImageForSpot(5, joueur: 0)
            IA = false
            CheckVictoire()
            return
        }
        
        TTTLabel.hidden = false
        TTTLabel.text = "Hum hum, ça passe pas !!"
        
        recommencer()
        
        IA = false
    }
    
    func ouJouer(location:String,pattern:String) -> Int {
        let Gpattern = "011"
        let Mpattern = "101"
     // let Dpattern = "110"
        
        switch location {
        case "Top":
            if pattern == Gpattern{
                return 1
            }else if pattern == Mpattern{
                return 2
            }else {
                return 3
            }
        case "Middle":
            if pattern == Gpattern{
                return 4
            }else if pattern == Mpattern{
                return 5
            }else {
                return 6
            }
        case "Bottom":
            if pattern == Gpattern{
                return 7
            }else if pattern == Mpattern{
                return 8
            }else {
                return 9
            }
        case "Gauche":
            if pattern == Gpattern{
                return 1
            }else if pattern == Mpattern{
                return 4
            }else {
                return 7
            }
        case "VMiddle":
            if pattern == Gpattern{
                return 2
            }else if pattern == Mpattern{
                return 5
            }else {
                return 8
            }
        case "Droite":
            if pattern == Gpattern{
                return 3
            }else if pattern == Mpattern{
                return 6
            }else {
                return 9
            }
            
        case "GiagGaucheDroite":
            if pattern == Gpattern{
                return 3
            }else if pattern == Mpattern{
                return 5
            }else {
                return 7
            }
        case "DiagDroiteGauche":
            if pattern == Gpattern{
                return 1
            }else if pattern == Mpattern{
                return 5
            }else {
                return 9
            }
            
        default: return 5
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

