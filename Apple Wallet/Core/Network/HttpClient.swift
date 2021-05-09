//
//  HttpClient.swift
//  Apple Wallet
//
//  Created by Jordy Gonzalez on 8/05/21.
//

import Foundation
import Alamofire

class HttpClient {
    static let `default` = HttpClient()
    
    func performRequest(to url: String,
                                      httpMethod: HttpMethod,
                                      keyPath: String? = nil,
                                      body: [String: AnyObject]? = nil,
                                      completitionHandler: @escaping(_ response: Data?, _ error: Error?) -> Void
    ) {
        AF.request(url,
                   method: HTTPMethod(rawValue: httpMethod.rawValue.uppercased()),
                   parameters: body).validate().responseData { (response) in
                        if let result = response.value {
                            completitionHandler(result, nil)
                        }

                        if let error = response.error {
                            completitionHandler(nil, error)
                        }
                   }
            
        
           
    }
}


enum HttpMethod: String {
    case get
    case post
}
