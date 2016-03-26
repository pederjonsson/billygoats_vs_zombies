//
//  PlayerGoat.swift
//  Bockarna bruse
//
//  Created by peder jonsson on 26/03/16.
//  Copyright © 2016 PederJonsson. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class PlayerGoat:SKSpriteNode {

    var alive = true
    var normalSpeed: CGFloat = 120.0
    let synthesizer = AVSpeechSynthesizer()
    
    //max distance from player (the big billy goat)
    let kMaxDistance:CGFloat = 150
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func die(){
        self.alive = false
        synthesizer.speakUtterance(getUtterance("bähähäähähähähäähähähhä"))
    }
    
    func getUtterance(words:String) -> AVSpeechUtterance{
        let utterance = AVSpeechUtterance(string: words)
        utterance.rate = 0.6
        utterance.pitchMultiplier = 1.5
        utterance.voice = AVSpeechSynthesisVoice(language: "sv-SE")
        return utterance
    }
   
    
}