//
//  API.swift
//  AngelHackMoscow
//
//  Created by Alexander Danilyak on 01/07/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class API {
    
    private let apiUrl = "http://machineheads.co:3000"
    
    func findLooks(image: UIImage,
                   onSuccess: (([Look]) -> Void)? = nil,
                   onError: ((String) -> Void)? = nil) {
        
        
        guard let data = UIImageJPEGRepresentation(correctlyOrientedImage(image: image), 0.5) else {
            return
        }
        
        let path: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                               FileManager.SearchPathDomainMask.userDomainMask,
                                                               true)[0] + "/temp.jpg"
        
        do {
            try _ = data.write(to: URL.init(fileURLWithPath: path))
        } catch {
            print("[FIND LOOKS] WRITE ERROR")
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(URL.init(fileURLWithPath: path), withName: "file")
        },
                         usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
                         to: apiUrl + "/outfits",
                         method: .post,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    switch response.result {
                                    case .success(_):
                                        if response.response!.statusCode >= 400 {
                                            onError?(localize(key: "errorDescription") + " [\(response.response!.statusCode)]")
                                            print("[FIND LOOKS] ERROR")
                                        } else {
                                            let result = JSON(response.result.value!)
                                            let looks = Look.parseLooks(json: result)
                                            onSuccess?(looks)
                                            print("[FIND LOOKS] SUCCESS")
                                        }
                                    case .failure(_):
                                        onError?(localize(key: "errorDescription"))
                                        print("[ALGO] ERROR")
                                    }
                                }
                            case .failure(_):
                                onError?(localize(key: "errorDescription"))
                                print("[ALGO] ERROR")
                            }
        })
    }
    
}
