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
    
    init(songTitle : String, artistName : String, albumTitle : String) {
        self.songTitle = songTitle;
        self.artistName = artistName;
        self.albumTitle = albumTitle;
    }
}



class MusicData{
    static let sharedInstance = MusicData();
    
    var songs: [SongInfo]
    
    init(){
        songs = [];
    }
    
    public func LoadSongs(songsTableView : SongsTableViewController){
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                let songQuery = MPMediaQuery.songs();
                for item in songQuery.items! {
                    /*
                    print(item.title!);
                    print(item.artist!);
                    print(item.albumTitle!);
                    */
                    var artist : String = "";
                    if (item.artist != nil){
                        artist = item.artist!
                    }
                    var albumTitle : String = "";
                    if (item.albumTitle != nil){
                        albumTitle = item.albumTitle!
                    }
                    let aSong : SongInfo = SongInfo(songTitle: item.title!, artistName: artist, albumTitle: albumTitle);
                    self.songs.append(aSong);
                }
                print(self.songs.count);
                songsTableView.reloadData();
                
            } else {
                //displayMediaLibraryError()
            }
        }
        
        
    }

}
