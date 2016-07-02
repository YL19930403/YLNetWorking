//
//  ViewController.swift
//  YLNewWorking
//
//  Created by 余亮 on 16/7/2.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        YLNet.request("GET", url: "https://github.com/YL19930403/YLNetWorking", form: ["q":"jeopardize"], success: { (data) in
//            print(String(data: data!, encoding: NSUTF8StringEncoding))
//        }) { (err) in
//            
//        }
        
        YLHTTP.shareInstance.fetch("http://cn.bing.com/dict/").parse(["q":"jeopardize"]).go({ (result ) -> (Void) in
                print(result)
            }) { (err ) -> (Void) in
                print(err)
        }
        
    }
    
}





























