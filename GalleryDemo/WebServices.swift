//
//  WebServices.swift
//  GalleryDemo
//
//  Created by maulik on 17/08/21.
//

import Foundation
import UIKit
import Alamofire
//import JGProgressHUD


//var preloader:JGProgressHUD = JGProgressHUD(style: .light)

class ApiManager {
    
    
    
    func requestWith<T>(method: HTTPMethod = .get, endPoint: String, loader: Bool = false, params: [String: Any] = [:], model: T.Type, success: @escaping (AnyObject) -> Void, failure: ((AnyObject) -> Void)? = nil) where T: Codable {
        

        let newParam :[String: Any] = params
        
        
        
        AF.request(endPoint, method: method, parameters: method == .get ? nil : method == .put ? nil : newParam,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            print("===> URL: \(endPoint)")
            print("===> Sending Dict : \(newParam)")
            
            switch response.result {
            case .success(let data):
                
                do {
                    
                    let stringData = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String
                    let dictData = self.convertToDictionary(text: stringData)
                    print("Responce ==> \(dictData)")
                    
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(model, from: response.data!)

                    
                    //print(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String)
                    
                    success(responseData as AnyObject)
                } catch {
                    let stringData = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String
                    let dictData = self.convertToDictionary(text: stringData)
                    print("Error = \(error)")
                    if failure != nil {
                        failure!(error.localizedDescription as AnyObject)
                    }
                }
                
            case .failure(_):
                print("Response failed.............")
                //return (failure ?? "API Developer issue" as? (AnyObject) -> Void)
            }
            
            switch response.result {
            case .success:
                print(response)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
