//
//  YLNet.swift
//  YLNewWorking
//
//  Created by 余亮 on 16/7/2.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class YLNet: NSObject {
    //如果参数是GET类型，则将参数进行URL encode，追加到原始url的后面,如果参数是POST，则URL不变
    /**
        method : 请求类别
        url    : 目标地址
        form   :  参数表
        success:  成功的闭包回调
        fail   :  失败的闭包回调
     */
    class func request(method : String = "GET", url:String, form:Dictionary<String ,AnyObject> = [:], success:((data : NSData?)->())?, fail:((err:NSError?)->())?){
            var innerUrl = url
        if method == "GET"{
            // GET 请求的，处理完后直接 append 到 url 后面
            innerUrl += "?" + YLNet().buildParams(form)
        }
        
        
        let req = NSMutableURLRequest(URL: NSURL(string: innerUrl)!)
        req.HTTPMethod = method
        //如果参数是 POST 的情况，设置 Content-Type 为 application/x-www-form-urlencoded, 并将参数进行 URL encode，并添加到 body 中
        //POST 需要用 UTF8 encode 一下，放在 request 的 body 里
        if (method == "POST"){
            req.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            print("POST PARAMS =  \(form)")
            req.HTTPBody = YLNet().buildParams(form).dataUsingEncoding(NSUTF8StringEncoding)
        }
        //发送请求
        let session = NSURLSession.sharedSession()
        print(req.description)
        let task = session.dataTaskWithRequest(req) { (data, response, errro ) in
            if (errro != nil ){
                fail!(err :errro)
            }else {
                if ((response as! NSHTTPURLResponse).statusCode == 200){
                    success!(data:data)
                }else {
                    fail!(err:errro)
                    print(response)
                }
            }
    }
        task.resume()
    
}
     func buildParams(params:[String:AnyObject]) -> String{
        var components : [(String ,String)] = []
        for key in Array(params.keys).sort(){
            let value : AnyObject! = params[key]
            components += self.queryComponents(key , value)
        }
        return (components.map{"\($0)=\($1)"} as [String]).joinWithSeparator("&")
        
    
}

    //把输入的字典转为键值对的数组(key, value)
    
    /**
        思路：1.如果value是简单的类型，则 对其转义得到value
            2.如果value是数组，则用当前的key和value中的每一个元素组成tuple：[(key, subValue)]，递归执行步骤1
            3.如果value是字典，先把value转为键值对数组，得到键值对数组后，递归执行步骤1
     */
     func queryComponents(key:String , _ value : AnyObject)-> [(String , String)] {
        var components : [(String, String)] = []
        if let dic = value as? [String:AnyObject]{     //value为字典
            for (nestedKey, value ) in dic{
                components += queryComponents("\(key)[\(nestedKey)]", value )
            }
        }else if let array = value as? [AnyObject]{   //VALUE为数组
            for value in array {
                components += queryComponents("\(key)", value )
            }
        }else {         //value为简单类型
            components.appendContentsOf([(escape(key) , escape("\(value)"))])
        }
        return components
    }
    

     func escape(string:String) -> String{
        let legalURLCharacterToBeEscape : CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string , nil , legalURLCharacterToBeEscape, CFStringBuiltInEncodings.UTF8.rawValue) as String
        
        
}


}





































