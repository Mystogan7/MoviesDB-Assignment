//
//  Extensions+Strings.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/21/19.
//

import Foundation
import CommonCrypto
import UIKit

extension String  {
   
    var MD5: String? {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
          for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
          }
        result.deallocate()
        return String(format: hash as String)
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
