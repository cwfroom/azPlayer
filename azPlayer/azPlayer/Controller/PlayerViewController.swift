//
//  PlayerViewController.swift
//  azPlayer
//
//  Created by Loli on 1/29/18.
//  Copyright © 2018 Wenfei Cao. All rights reserved.
//

import UIKit
import MediaPlayer
import MediaToolbox

class PlayerViewController: UIViewController {
    let data : MusicData = MusicData.sharedInstance;
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PlayPauseButton: UIButton!
    
    let mediaPlayer = MPMusicPlayerApplicationController.applicationMusicPlayer;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSong(index: data.currentIndex);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setSong(index: data.currentIndex);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSong(index : Int){
        var nowPlaying : Bool = false;
        if (mediaPlayer.playbackState == .playing){
            mediaPlayer.pause();
            nowPlaying = true;
        }
        let item = MPMediaQuery.songs().items![index];
        let collection : MPMediaItemCollection = MPMediaItemCollection(items: [item]);
        mediaPlayer.setQueue(with: collection);
        TitleLabel.text = data.songs[index].songTitle;
        if (nowPlaying){
            mediaPlayer.play();
        }
    }
    
    
    @IBAction func playPauseButtonTouch(_ sender: Any) {
        if (mediaPlayer.playbackState == .playing){
            mediaPlayer.pause();
            PlayPauseButton.setTitle("Play", for: .normal);
        }else{
            PlayPauseButton.setTitle("Pause", for: .normal);
            mediaPlayer.play();
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
