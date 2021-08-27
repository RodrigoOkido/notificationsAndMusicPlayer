//
//  MusicPlayerController.swift
//  Notifications
//
//  Created by Rodrigo Yukio Okido on 27/08/21.
//

import UIKit
import AVFoundation


struct Music {
    let image: UIImage
    let name: String
    let artist: String
    let path: String
    let format: String
}

class MusicPlayerController: UIViewController, AVAudioPlayerDelegate, ObservableObject {

    // MARK: CLASS VARIABLES
    @Published var playSong: Music = Music (image: UIImage(named: "nature1.jpg")!, name: "The Way Home", artist: "GoodBMusic", path: "the-way-home", format: "mp3")
    @Published var playSong2: Music = Music (image: UIImage(named: "nature2.jpg")!, name: "Cinematic Chillhop Main", artist: "GoodBMusic", path: "cinematic-chillhop-main", format: "mp3")
    @Published var actualMusic: Music?
    var player: AVAudioPlayer?
    

    
    // MARK: STORYBOARD VARIABLES
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var musicImage: UIImageView!
    
    
    // MARK: STORYBOARDS VAR ACTIONS
    @IBAction func playMedia(_ sender: Any) {
        let urlString = Bundle.main.path(forResource: actualMusic?.path, ofType: playSong.format)
        do{
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            guard let urlString = urlString else {
                return
            }
            
            self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            self.player?.delegate = self
            
            guard let player = player else{
                return
            }
            
            if playButton.backgroundImage(for: .normal) == UIImage(systemName: "play.fill") {
                
                
                playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
                player.play()
            } else {
                playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
                player.pause()

            }
            
        }catch{
            print("Something went bad")
        }
    }
    
    @IBAction func backMusic(_ sender: Any) {
        musicImage.image = playSong.image
        musicNameLabel.text = "The Way Home"
        artistNameLabel.text = "GoodBMusic"
        actualMusic = playSong
        player?.pause()
        playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    
    @IBAction func forwardMusic(_ sender: Any) {
        musicImage.image = playSong2.image
        musicNameLabel.text = "Cinematic Chillhop Main"
        artistNameLabel.text = "GoodBMusic"
        actualMusic = playSong2
        player?.pause()
        playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicImage.clipsToBounds = true
        musicImage.layer.cornerRadius = 20
        musicImage.image = playSong.image
        musicNameLabel.text = "The Way Home"
        artistNameLabel.text = "GoodBMusic"
        actualMusic = playSong
        playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)

    }
}


