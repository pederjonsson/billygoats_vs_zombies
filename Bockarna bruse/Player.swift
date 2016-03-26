//
//  Player.swift
//  Bockarna bruse
//
//  Created by peder jonsson on 26/03/16.
//  Copyright © 2016 PederJonsson. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Player:SKSpriteNode {
    
    let playerSpeed: CGFloat = 100.0
    let synthesizer = AVSpeechSynthesizer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func killZombie(){
        synthesizer.speakUtterance(getUtterance("bähä"))
    }
    
    func goal(){
        synthesizer.speakUtterance(getUtterance("jippiii"))
    }
    
    func getUtterance(words:String) -> AVSpeechUtterance{
        let utterance = AVSpeechUtterance(string: words)
        utterance.rate = 0.3
        utterance.pitchMultiplier = 0.3
        utterance.voice = AVSpeechSynthesisVoice(language: "sv-SE")
        return utterance
    }
    
    
}