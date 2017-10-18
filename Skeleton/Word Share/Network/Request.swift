//
//  Request.swift
//  Skeleton
//
//  Created by BestPeers on 29/05/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit

class Request: NSObject {

    var urlPath: String
    var requestType: NSInteger
    var fileData: Data
    var dataFilename: String
    var fileName: String
    var mimeType: String
    var headers: [String: String]?
    var parameters: Dictionary<String, Any>
    
    override init() {
        urlPath = ""
        requestType = 0
        fileData = Data()
        dataFilename = ""
        fileName = ""
        mimeType = ""
        parameters = [:]
        super.init()
    }
    
    public func getParams() -> Dictionary<String, Any> {
        return parameters
    }
}