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

    var normalSpeed: CGFloat = 120.0
    let synthesizer = AVSpeechSynthesizer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func speak(){
        synthesizer.speakUtterance(getUtterance("testing the voice of smaller billy goats"))
    }
    
    func getUtterance(words:String) -> AVSpeechUtterance{
        let utterance = AVSpeechUtterance(string: words)
        utterance.rate = 1.4
        utterance.pitchMultiplier = 1.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        return utterance
    }
   
    
}