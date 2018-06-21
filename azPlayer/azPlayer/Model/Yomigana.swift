//
//  Yomigana.swift
//  azPlayer
//
//  Created by Loli on 6/19/18.
//  Copyright © 2018 Wenfei Cao. All rights reserved.
//

import Foundation
import Alamofire

class Yomigana{
    public static func Convert(_ str : String, completion: @escaping (_ result:String)->Void){
        //let url = ;
        let appID = "api_id";
        let parameters : [String : Any] = ["app_id":appID,"sentence":str,"output_type":"hiragana"];
        
        Alamofire.request( "https://labs.goo.ne.jp/api/hiragana", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let json = response.result.value as? [String : Any]{
                    if let converted = json["converted"] as? String{
                        print(converted);
                        completion(converted);
                    }
                }
        }
   
    }
}
