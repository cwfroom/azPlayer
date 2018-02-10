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
    var playingIndex : Int = 0;
    var playingQueue : [Int] = [];
    
    @IBOutlet weak var CoverImage: UIImageView!
    @IBOutlet weak var PlayPauseButton: UIButton!
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ArtistLabel: UILabel!
    @IBOutlet weak var SkipCountLabel: UILabel!
    @IBOutlet weak var PlayCountLabel: UILabel!
    @IBOutlet weak var TimePastLabel: UILabel!
    @IBOutlet weak var TimeRemainingLabel: UILabel!
    
    @IBOutlet weak var TimeLine: UIProgressView!
    var timer = Timer();
    
    let mediaPlayer = MPMusicPlayerApplicationController.systemMusicPlayer;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSong(index: data.currentIndex);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (playingIndex != data.currentIndex){
            setSong(index: data.currentIndex);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSong(index : Int){
        playingIndex = index;
        var nowPlaying : Bool = false;
        if (mediaPlayer.playbackState == .playing){
            mediaPlayer.pause();
            timer.invalidate();
            nowPlaying = true;
        }
        let item = MPMediaQuery.songs().items![index];
        let collection : MPMediaItemCollection = MPMediaItemCollection(items: [item]);
        mediaPlayer.setQueue(with: collection);
        TitleLabel.text = data.songs[index].songTitle;
        ArtistLabel.text = data.songs[index].artistName;
        if (item.artwork != nil){
            let coverImage = item.artwork!.image(at: CGSize(width: 300, height:300));
            CoverImage.image = coverImage;
        }else{
            CoverImage.image = UIImage(named: "DefaultCover");
        }
        PlayCountLabel.text = "Played " + String(item.playCount);
        SkipCountLabel.text = "Skipped " + String(item.skipCount);
        
        if (nowPlaying){
            mediaPlayer.play();
            startTimer();
        }
    }
    
    func pickRandomSong(){
        let rand : Int = Int(arc4random_uniform(UInt32(data.songs.count)));
        let randIndex : Int = data.songs[rand].index;
        data.currentIndex = randIndex;
        setSong(index: randIndex);
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        if (mediaPlayer.playbackState != .playing){
            pickRandomSong();
            return;
        }
        let pastTime  = mediaPlayer.currentPlaybackTime.magnitude;
        let totalTime = (mediaPlayer.nowPlayingItem?.playbackDuration.magnitude)!;
        TimeLine.progress = Float(pastTime / totalTime);
        TimePastLabel.text = timeToString(seconds: Int(pastTime));
        TimeRemainingLabel.text = timeToString(seconds: Int(totalTime) - Int(pastTime));
    }
    
    func resetTime(){
        TimePastLabel.text = "00:00";
        TimeRemainingLabel.text = "00:00";
    }
    
    func timeToString(seconds: Int) -> String{
        let min : Int = seconds / 60;
        let sec : Int = seconds - min * 60;
        return String(format:"%02d",min) + ":" + String(format:"%02d",sec);
    }
    
    @IBAction func playPauseButtonTouch(_ sender: Any) {
        if (mediaPlayer.playbackState == .playing){
            mediaPlayer.pause();
            timer.invalidate();
            PlayPauseButton.setTitle("Play", for: .normal);
        }else{
            PlayPauseButton.setTitle("Pause", for: .normal);
            mediaPlayer.play();
            startTimer();
        }
    }
    @IBAction func prevButtonTouch(_ sender: Any) {
        //mediaPlayer.skipToPreviousItem();
        pickRandomSong();
    }
    
    @IBAction func nextButtonTouch(_ sender: Any) {
        //mediaPlayer.skipToNextItem();
        pickRandomSong();
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
