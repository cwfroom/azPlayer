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
    var songTitle:  String;
    var titleReading : String;
    var artistName: String;
    var albumTitle: String;
    var index : Int
    
    init(songTitle : String, titleReading: String, artistName : String, albumTitle : String, index : Int) {
        self.songTitle = songTitle;
        self.titleReading = titleReading;
        self.artistName = artistName;
        self.albumTitle = albumTitle;
        self.index = index;
    }
}



class MusicData{
    static let sharedInstance = MusicData();
    
    var songs : [SongInfo];
    var currentIndex : Int = 0;
    var sectionTitles : [String];
    var songDic : [String:[SongInfo]];
    var readingDic : [String:String];
    
    let readingDicFileName = "ReadingDictionary.txt";
    
    init(){
        songs = [];
        sectionTitles = [];
        songDic = [:];
        readingDic = [:];
        loadReadingDic();
    };
    
    func getFileURL(fileName : String) -> URL{
        let fileManager = FileManager.default;
        if (!fileManager.fileExists(atPath: fileName)){
            fileManager.createFile(atPath: fileName, contents: nil, attributes: nil);
        }
        let dir = fileManager.urls(for:.documentDirectory,in:.userDomainMask);
        return (dir.first?.appendingPathExtension(fileName))!;
    }
    
    private func loadReadingDic(){
        readingDic = [:];
        let fileURL = getFileURL(fileName: readingDicFileName);
        var stringfied : String = "";
        do{
            stringfied = try String(contentsOf: fileURL,encoding:.utf8);
        }catch{
            print("Failed to load from reading dic");
        }
        let entries = stringfied.components(separatedBy: "\n");
        for entry in entries {
            print(entry+"\n");
            let entrySplit = entry.components(separatedBy: " ");
            if (entrySplit.count > 1){
                readingDic[entrySplit[0]] = entrySplit[1];
            }
        }
        
    }
    
    private func saveReadingDic(){
        let fileURL = getFileURL(fileName: readingDicFileName);
        var stringfied : String = "";
        for (title,reading) in readingDic {
            stringfied += title + " " + reading + "\n";
        }
        do{
            try stringfied.write(to: fileURL, atomically: false, encoding: .utf8);
        }catch{
            print("Failed to write to reading dic");
        }
    }
    
    private func deleteReadingDic(){
        let fileManager = FileManager.default;
        let dir = fileManager.urls(for:.documentDirectory,in:.userDomainMask);
        let fileURL = (dir.first?.appendingPathExtension(readingDicFileName))!;
        do{
            try fileManager.removeItem(at: fileURL);
        }catch{
            print("Failed to delete reading dic");
        }
    }
    
    public func LoadSongs(songsTableView : SongsTableViewController){
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                let songQuery = MPMediaQuery.songs();
                
                for i in 0...songQuery.items!.count - 1{
                    let item = songQuery.items![i];
                    let songTitle = item.title!;
                    var artist : String = "";
                    if (item.artist != nil){
                        artist = item.artist!
                    }
                    var albumTitle : String = "";
                    if (item.albumTitle != nil){
                        albumTitle = item.albumTitle!
                    }
                    var titleReading = songTitle;
                    if let reading = self.readingDic[songTitle]{
                        titleReading = reading;
                    }
                    
                    let aSong : SongInfo = SongInfo(songTitle: songTitle, titleReading: titleReading, artistName: artist, albumTitle: albumTitle,index : i);
                    self.songs.append(aSong);
                    
                    let sectionTitle = String(item.title!.prefix(1));
                    if var sectionSongs = self.songDic[sectionTitle]{
                        sectionSongs.append(aSong);
                        self.songDic[sectionTitle] = sectionSongs;
                    }else{
                        self.songDic[sectionTitle] = [aSong];
                    }
                }
                self.sectionTitles = [String](self.songDic.keys);
                self.sectionTitles = self.sectionTitles.sorted();
                print(self.songs.count);
                songsTableView.reloadData();
                
            } else {
                //displayMediaLibraryError
            }
        }
        
    }
    

}
