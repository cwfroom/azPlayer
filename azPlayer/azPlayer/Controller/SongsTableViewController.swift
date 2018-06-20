//
//  SongsTableViewController.swift
//  azPlayer
//
//  Created by Loli on 1/22/18.
//  Copyright © 2018 Wenfei Cao. All rights reserved.
//

import UIKit
import MediaPlayer

class SongsTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let data : MusicData = MusicData.sharedInstance;
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    var editMode : Bool = false;
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        data.LoadSongs(self);
        
        self.tableView.reloadData();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.sectionTitles.count;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = data.sectionTitles[section];
        return data.songDic[sectionTitle]!.count;
    }

    func reloadData(){
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongsTableCell;
        let sectionTitle = data.sectionTitles[indexPath.section];
        cell.TitleLabel.text = data.songDic[sectionTitle]![indexPath.row].songTitle;
        if (editMode){
            cell.ArtistLabel.text = data.songDic[sectionTitle]![indexPath.row].titleReading;
        }else{
            cell.ArtistLabel.text = data.songDic[sectionTitle]![indexPath.row].artistName;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (editMode){
            let sectionTitle = data.sectionTitles[indexPath.section];
            let songInfo = data.songDic[sectionTitle]![indexPath.row];
            
            let alert = UIAlertController(title: "Edit Reading", message: songInfo.songTitle, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = songInfo.titleReading
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let reading = alert?.textFields![0].text;
                self.data.UpdateSong(self,songInfo,sectionTitle,reading!);
                
                //print("Text field: \(String(describing: textField?.text))")
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            data.currentIndex = data.songDic[data.sectionTitles[indexPath.section]]![indexPath.row].index;
            self.tabBarController?.selectedIndex = 1;
        }
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data.sectionTitles[section];
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return data.sectionTitles;
    }

    
    @IBAction func editButtonTouch(_ sender: Any) {
        editMode = !editMode;
        if (editMode){
            self.editButton.setTitle("Done", for:.normal);
        }else{
            self.editButton.setTitle("Edit", for:.normal);
        }
        self.tableView.reloadData();
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
