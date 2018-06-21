//
//  ReadingViewController.swift
//  azPlayer
//
//  Created by Loli on 6/20/18.
//  Copyright © 2018 Wenfei Cao. All rights reserved.
//

import UIKit

class ReadingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readingTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setTitle(_ title : String){
        titleLabel.text = title;
    }
    
    public func setReading(_ reading : String){
        readingTextField.text = reading;
    }
    
    public func getReading() -> String {
        return readingTextField.text!;
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
