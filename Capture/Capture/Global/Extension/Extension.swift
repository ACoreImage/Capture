
//
//  Extension.swift
//  Capture
//
//  Created by ShawnDu on 15/11/9.
//  Copyright © 2015年 ShawnDu. All rights reserved.
//

import Foundation

extension Array where Element : AnyObject {
    func last() -> Element {
        return self[self.count - 1]
    }
}

extension UIView {
    var dWidth: CGFloat {
        return self.frame.size.width
    }
    
    var dHeight: CGFloat {
        return self.frame.size.height
    }
}