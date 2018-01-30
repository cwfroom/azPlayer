//
//  MusicData.swift
//  azPlayer
//
//  Created by Loli on 1/22/18.
//  Copyright © 2018 Wenfei Cao. All rights reserved.
//

import Foundation
import MediaPlayer

class SongInfo {
    var songTitle:  String
    var artistName: String
    var albumTitle: String
    var index : Int
    
    init(songTitle : String, artistName : String, albumTitle : String, index : Int) {
        self.songTitle = songTitle;
        self.artistName = artistName;
        self.albumTitle = albumTitle;
        self.index = index;
    }
}



class MusicData{
    static let sharedInstance = MusicData();
    
    var songs: [SongInfo]
    var currentIndex : Int = 0;
    
    init(){
        songs = [];
    }
    
    public func LoadSongs(songsTableView : SongsTableViewController){
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                let songQuery = MPMediaQuery.songs();
                
                for i in 0...songQuery.items!.count - 1{
                    let item = songQuery.items![i];
                    
                    var artist : String = "";
                    if (item.artist != nil){
                        artist = item.artist!
                    }
                    var albumTitle : String = "";
                    if (item.albumTitle != nil){
                        albumTitle = item.albumTitle!
                    }
                    let aSong : SongInfo = SongInfo(songTitle: item.title!, artistName: artist, albumTitle: albumTitle,index : i);
                    self.songs.append(aSong);
                }
                print(self.songs.count);
                songsTableView.reloadData();
                
            } else {
                //displayMediaLibraryError
            }
        }
        
        
    }

}
