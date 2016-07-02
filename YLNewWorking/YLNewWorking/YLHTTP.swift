//
//  YLHTTP.swift
//  YLNewWorking
//
//  Created by 余亮 on 16/7/3.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

enum RequestMethod {
    case post
    case Get
}

class YLHTTP {
    
    private var method : RequestMethod
    private let hostName = ""
    private var curUrl = ""
    private var parameters :[String: AnyObject] = [:]
    static let shareInstance = YLHTTP(m:.Get)
    init(m:RequestMethod){
        method = m
        setDefaultParas()
    }
    
    
    ///实现链式编程，返回的都是自身
    //生成GET请求
    func fetch(url:String) -> YLHTTP{
        setDefaultParas()
        curUrl = "\(hostName)\(url)"
        self.method = .Get
        return self
    }
    
    //生成POST请求
    func post(url:String) -> YLHTTP{
        setDefaultParas()
        curUrl = "\(hostName)\(url)"
        self.method = .post
        return self
    }
    
    //设置方法参数
    func parse(p:[String:AnyObject]) -> YLHTTP{
        _ = p.reduce("", combine: { (str , p ) -> String  in
             parameters[p.0] = p.1
            return ""
        })
        return self
    }
    
    //请求的具体操作
    func go(success:((String)->(Void))? , failure : ((NSError)->(Void))?){
        var ylmethod = ""
        if (method == .Get){
            ylmethod = "GET"
        }else{
            ylmethod = "POST"
        }
        
        YLNet.request(ylmethod, url: curUrl, form: parameters, success: { (data) in
                print("request successed in \(self.curUrl)")
                let result = String(data: data! , encoding: NSUTF8StringEncoding)
               success!(result!)
            }) { (err) in
                print("request failed in \(self.curUrl)")
                failure!(err!)
        }
    }
    
   private func setDefaultParas(){
            self.parameters = [:]
            _ = defaultParameter().reduce("", combine: { (str , p ) -> String  in
            self.parameters[p.0] = p.1
                return ""
        })
    }
    
    
    
    
    private func defaultParameter()->[String:AnyObject]{
        var result : [String:AnyObject]
            = [:]
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"]
        result["version"] = version
        result["app_type"] = "ylhttp"
        return result
        
    }
}





































