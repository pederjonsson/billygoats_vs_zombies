//
//  Commentator.swift
//  Bockarna bruse
//
//  Created by peder jonsson on 26/03/16.
//  Copyright © 2016 PederJonsson. All rights reserved.
//

import SpriteKit
import AVFoundation

class Commentator {
    
    
    let defaultLanguage = "en-GB"
    let swedish = "sv-SE"
    let synthesizer = AVSpeechSynthesizer()
    
    func presentGame(){
        synthesizer.speakUtterance(getUtterance("this is a test voice. The zombies are a deadly team facing the three billly goats which has the rather unusual startup of one one one, while we can see that the zombies are going with the classic three four two tactic. And as you can hear they are rather excited for this matchup."))
    }
    
    func goal(){
        let utterance = getUtterance("the three billy goats score again thanks to their amazing team spirit, the zombies are simply standing there in total shame, probably blaming eachother for not being more alive")
        
        utterance.pitchMultiplier = 1.2
        synthesizer.speakUtterance(utterance)
    }
    
    func getUtterance(words:String) -> AVSpeechUtterance{
        
        let utterance = AVSpeechUtterance(string: words)
        utterance.voice = AVSpeechSynthesisVoice(language: defaultLanguage)
        return utterance
    }
    
}