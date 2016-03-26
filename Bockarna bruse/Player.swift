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
    
    func goal(){
        synthesizer.speakUtterance(getUtterance("yes me the big billy goat scored"))
    }
    
    func getUtterance(words:String) -> AVSpeechUtterance{
        let utterance = AVSpeechUtterance(string: words)
        utterance.rate = 1.0
        utterance.pitchMultiplier = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        return utterance
    }
    
    
}