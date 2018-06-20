//
//  MusicData.swift
//  azPlayer
//
//  Created by Loli on 1/22/18.
//  Copyright © 2018 Wenfei Cao. All rights reserved.
//

import Foundation
import MediaPlayer

class SongInfo : NSObject, NSCopying{
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
    
    required init(_ other : SongInfo) {
        songTitle = other.songTitle;
        titleReading = other.titleReading;
        artistName = other.artistName;
        albumTitle = other.albumTitle;
        index = other.index;
    }
    
    func copy(with zone: NSZone? = nil) -> Any{
        return type(of: self).init(self);
    }
    
}



class MusicData{
    static let sharedInstance = MusicData();
    
    var songs : [SongInfo];
    var currentIndex : Int = 0;
    var sectionTitles : [String];
    let properTitles = [ "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","あ","か","さ","た","な","は","ま","や","ら","わ","#"];
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
    
    private func getFileURL(_ fileName : String) -> URL{
        let fileManager = FileManager.default;
        let dir = fileManager.urls(for:.documentDirectory,in:.userDomainMask);
        let fileURL = (dir.first?.appendingPathComponent(fileName))!;
        if (!fileManager.fileExists(atPath: fileURL.path)){
            do{
                try "".write(to: fileURL, atomically: false, encoding: .utf8);
            }catch{
                print("Failed to create and write to " + fileName);
            }
        }
        return fileURL;
    }
    
    private func loadReadingDic(){
        readingDic = [:];
        let fileURL = getFileURL(readingDicFileName);
        var stringfied : String = "";
        do{
            stringfied = try String(contentsOf: fileURL,encoding:.utf8);
        }catch{
            print("Failed to load from reading dictionary\n");
            print(error.localizedDescription);
        }
        let entries = stringfied.components(separatedBy: "\n");
        for entry in entries {
            print(entry+"\n");
            let entrySplit = entry.components(separatedBy: "::");
            if (entrySplit.count > 1){
                readingDic[entrySplit[0]] = entrySplit[1];
            }
        }
        
    }
    
    public func saveReadingDic(){
        let fileURL = getFileURL(readingDicFileName);
        var stringfied : String = "";
        for (title,reading) in readingDic {
            stringfied += title + "::" + reading + "\n";
        }
        do{
            try stringfied.write(to: fileURL, atomically: false, encoding: .utf8);
        }catch{
            print("Failed to write to reading dictionary\n");
            print(error.localizedDescription);
        }
    }
    
    private func deleteReadingDic(){
        let fileManager = FileManager.default;
        let dir = fileManager.urls(for:.documentDirectory,in:.userDomainMask);
        let fileURL = (dir.first?.appendingPathExtension(readingDicFileName))!;
        do{
            try fileManager.removeItem(at: fileURL)
        }catch{
            print("Failed to delete reading dic");
        }
    }
    
    private func kanaCatagorize(_ kana : String) -> String{
        if (kana >= "ぁ" && kana <= "お" ) || (kana >= "ァ" && kana <= "オ"){
            return "あ";
        }else if (kana >= "か" && kana <= "ご") || (kana >= "カ" && kana <= "ゴ"){
            return "か";
        }else if (kana >= "さ" && kana <= "ぞ") || (kana >= "サ" && kana <= "ゾ"){
            return "さ";
        }else if (kana >= "た" && kana <= "ど") || (kana >= "タ" && kana <= "ド"){
            return "た";
        }else if (kana >= "な" && kana <= "の") || (kana >= "ナ" && kana <= "ノ"){
            return "な";
        }else if (kana >= "は" && kana <= "ぽ") || (kana >= "ハ" && kana <= "ポ"){
            return "は";
        }else if (kana >= "ま" && kana <= "も") || (kana >= "マ" && kana <= "モ"){
            return "ま";
        }else if (kana >= "ゃ" && kana <= "よ") || (kana >= "ャ") && kana <= "ヨ"{
            return "や";
        }else if (kana >= "ら" && kana <= "ろ") || (kana >= "ラ" && kana <= "ロ"){
            return "ら";
        }else if (kana >= "ゎ" && kana <= "を") || (kana >= "ヮ" && kana <= "ヲ"){
            return "わ";
        }else if (kana == "ん") || (kana == "ン"){
            return "ん";
        }else if (kana == "ゔ") || (kana == "ヴ"){
            return "ゔ";
        }else if (kana == "ゕ" || kana == "ゖ") || (kana == "ヵ" || kana == "ヶ") {
            return "か";
        }else{
            return "#";
        }
    }
    
    private func catagorize(_ name : String) -> String{
        var firstLetter = String(name.prefix(1));
        if  (firstLetter >= "a" && firstLetter<="z") || (firstLetter >= "A" && firstLetter<="Z")  {
            firstLetter = firstLetter.capitalized;
        }else if (firstLetter >= "ぁ" && firstLetter <= "ゖ") || (firstLetter >= "ァ" && firstLetter <= "ヶ") {
            return kanaCatagorize(firstLetter);
        }else{
            firstLetter = "#";
        }
        return firstLetter;
    }
    
    public func UpdateSong(_ songsTableView : SongsTableViewController,_ songInfo : SongInfo,_ sectionTitle: String,_ reading : String){
        if (reading != ""){
            let songInfoCopy = songInfo.copy() as! SongInfo;
            songInfoCopy.titleReading = reading;
            if var sectionSongs = self.songDic[sectionTitle]{
                if let index = sectionSongs.index(of:songInfo){
                    sectionSongs.remove(at: index);
                }
                self.songDic[sectionTitle] = sectionSongs;
            }
            addSectionSong(songInfoCopy,true);
            songsTableView.reloadData();
            readingDic[songInfoCopy.songTitle] = songInfoCopy.titleReading;
            saveReadingDic();
        }
        
    }
    
    private func addSectionSong (_ songInfo : SongInfo,_ sort : Bool){
        let sectionTitle = self.catagorize(songInfo.titleReading);
        if var sectionSongs = self.songDic[sectionTitle]{
            sectionSongs.append(songInfo);
            if (sort){
                sectionSongs = sectionSongs.sorted(by: {$0.titleReading < $1.titleReading});
            }
            self.songDic[sectionTitle] = sectionSongs;
        }else{
            self.songDic[sectionTitle] = [songInfo];
        }
    }
    
    public func LoadSongs(_ songsTableView : SongsTableViewController){
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                let songQuery = MPMediaQuery.songs();
                
                for i in 0...songQuery.items!.count - 1{
                    let item = songQuery.items![i];
                    let songTitle = item.title!;
                    var artist : String = "Unknown";
                    if (item.artist != nil){
                        artist = item.artist!
                    }
                    var albumTitle : String = "Unknown";
                    if (item.albumTitle != nil){
                        albumTitle = item.albumTitle!
                    }
                    var titleReading = songTitle;
                    if let reading = self.readingDic[songTitle]{
                        titleReading = reading;
                    }
                    
                    let aSong : SongInfo = SongInfo(songTitle: songTitle, titleReading: titleReading, artistName: artist, albumTitle: albumTitle,index : i);
                    self.songs.append(aSong);
                    self.addSectionSong(aSong,false);
 
                }
                self.sectionTitles = [String](self.songDic.keys);
                self.sectionTitles = self.sectionTitles.sorted();
                songsTableView.reloadData();
                
            } else {
                //displayMediaLibraryError
            }
        }
        
    }
    

}
