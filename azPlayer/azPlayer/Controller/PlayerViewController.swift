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
        mediaPlayer.shuffleMode = .off;
        setSong(index: data.currentIndex);
        let nc = NotificationCenter.default;
        nc.addObserver(self, selector: #selector(self.onSongChange), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: mediaPlayer);
        mediaPlayer.beginGeneratingPlaybackNotifications();
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
        if (mediaPlayer.playbackState == .playing){
            mediaPlayer.pause();
            timer.invalidate();
        }
        playingQueue = [index];
        let item = MPMediaQuery.songs().items![index];
        updateUI(item: item);
        var items = [item];
        
        for _ in 0...100 {
            let randIndex : Int = getRandIndex();
            items.append(MPMediaQuery.songs().items![randIndex]);
            playingQueue.append(randIndex);
        }
        
        let collection : MPMediaItemCollection = MPMediaItemCollection(items: items);
        mediaPlayer.setQueue(with: collection);
        
        
        mediaPlayer.play();
        startTimer();
    }
    
    func updateUI(item : MPMediaItem){
        TitleLabel.text = data.songs[playingIndex].songTitle;
        ArtistLabel.text = data.songs[playingIndex].artistName;
        if (item.artwork != nil){
            let coverImage = item.artwork!.image(at: CGSize(width: 300, height:300));
            CoverImage.image = coverImage;
        }else{
            CoverImage.image = UIImage(named: "DefaultCover");
        }
        PlayCountLabel.text = "Played " + String(item.playCount);
        SkipCountLabel.text = "Skipped " + String(item.skipCount);
    }
    
    func getRandIndex() -> Int{
        return Int(arc4random_uniform(UInt32(data.songs.count)));
    }
    
    func pickRandomSong(){
        let rand : Int = Int(arc4random_uniform(UInt32(data.songs.count)));
        let randIndex : Int = data.songs[rand].index;
        data.currentIndex = randIndex;
        setSong(index: randIndex);
    }
    
    var totalTime : Double = 0;
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true);
        updatePlayPauseButtonText();
        totalTime = (mediaPlayer.nowPlayingItem?.playbackDuration)!;
    }
    
    
    @objc func updateTime(){
        if (mediaPlayer.playbackState != .playing){
            timer.invalidate();
            return;
        }
        let pastTime  = mediaPlayer.currentPlaybackTime;
        
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
        }else{
            mediaPlayer.play();
            startTimer();
        }
        updatePlayPauseButtonText();
    }
    
    func updatePlayPauseButtonText(){
        if (mediaPlayer.playbackState == .playing){
            PlayPauseButton.setTitle("Pause", for: .normal);
        }else{
            PlayPauseButton.setTitle("Play", for: .normal);
        }
    }
    
    @IBAction func prevButtonTouch(_ sender: Any) {
        mediaPlayer.skipToPreviousItem();
    }
    
    @IBAction func nextButtonTouch(_ sender: Any) {
        mediaPlayer.skipToNextItem();
    }
    
    @objc func onSongChange(_ notification : NSNotification){
        playingIndex = playingQueue[mediaPlayer.indexOfNowPlayingItem];
        data.currentIndex = playingIndex;
        updateUI(item: MPMediaQuery.songs().items![playingIndex])
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
