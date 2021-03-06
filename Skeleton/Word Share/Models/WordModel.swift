//
//  WordModel.swift
// WordPower
//
//  Created by Best Peers on 16/10/17.
//  Copyright © 2017 www.BestPeers.Skeleton. All rights reserved.
//

import UIKit

enum WordInfoType {
    case definitions
    case synonyms
    case antonyms
    case examples
    case hindiTranslation
    
    func getString() -> String{
        switch self {
        case .definitions:
            return "definitions"
        case .synonyms:
            return "synonyms"
        case .antonyms:
            return "antonyms"
        case .examples:
            return "examples"
        case .hindiTranslation:
            return "hindi translation"
        }
    }
}

class WordModel: NSObject {
    
    var word:String?
    var definitions: Array<Dictionary<String, String>> = []
    var synonyms: Array<String> = []
    var antonyms: Array<String> = []
    var examples: Array<String> = []
    var hindiTranslation:String?
}
