//
//  GameStatus.swift
//  Bockarna bruse
//
//  Created by peder jonsson on 27/03/16.
//  Copyright © 2016 PederJonsson. All rights reserved.
//

import Foundation
import UIKit

class GameStatus {
    
    var scoreLabel:UILabel
    var currentGoatScore = 0
    var currentZombieScore = 0
    
    init(scoreLabel:UILabel){
        self.scoreLabel = scoreLabel
        setScoreLabel()
    }
    
    func goalScoredByGoats(){
        currentGoatScore += 1
        setScoreLabel()
        
    }
    
    func goalScoredByZombies(){
        currentZombieScore += 1
        setScoreLabel()
    }
    
    func setScoreLabel(){
        self.scoreLabel.text = "BGS \(currentGoatScore) - \(currentZombieScore) ZFC "
    }
    
    
}
