//
//  String .swift
//  appWeather
//
//  Created by Vadim Baburin on 20.03.2023.
//

import Foundation

extension String {
 
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? self
    }
    
    var decodeUrl: String {
        return self.removingPercentEncoding ?? self
    }
}
