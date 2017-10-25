 //
//  NetworkAPIClient.swift
//  Word Share
//
//  Created by Best Peers on 18/10/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit

class NetworkAPIClient: NSObject {
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject)
                } else {
                    completion(false, json as AnyObject)
                }
            }
            }.resume()
    }
    
    private func post(request: NSMutableURLRequest?, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request!, method: "POST", completion: completion)
    }
    
    private func put(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "PUT", completion: completion)
    }
    
    private func get(request: NSMutableURLRequest?, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        if request != nil{
            dataTask(request: request!, method: "GET", completion: completion)
        }
        else
        {
            completion(false, Constants.kErrorMessage as AnyObject)
        }
    }
    
    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest? {
        
        if let url:URL = URL(string: "https://wordsapiv1.p.mashape.com/words/"+path) {
            let request = NSMutableURLRequest(url: url)
            request.setValue("gffsVZi52omsh52gxrT335Shh8aNp128WjajsnahxEMl6530yo", forHTTPHeaderField: "X-Mashape-Key")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            /*if let params = params {
             var paramString = ""
             for (key, value) in params {
             let escapedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
             let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
             paramString += "\(escapedKey)=\(escapedValue)&"
             }
             
             request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
             request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
             }
             
             if let token = token {
             request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
             }*/
            return request
        }
        return nil
    }
    
    private func translationClientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest? {
        
        if let url:URL = URL(string: "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20171024T105142Z.903b3e1c791c4cd5.3de81202f9dda907aab4dafbe86006f16141a764&lang=hi") {
            let request = NSMutableURLRequest(url: url)
            request.setValue("*/*", forHTTPHeaderField: "Accept")
            request.setValue("17", forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let escapedValue = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let paramString = "text=\(escapedValue ?? path)&"
            request.httpBody = paramString.data(using: String.Encoding.utf8)
            
            return request
        }
        return nil
    }
    
    func getObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        get(request: clientURLRequest(path: request.urlPath), completion: completion)
    }
    
    func getTranslationObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        post(request: translationClientURLRequest(path: request.urlPath), completion: completion)
    }
}
