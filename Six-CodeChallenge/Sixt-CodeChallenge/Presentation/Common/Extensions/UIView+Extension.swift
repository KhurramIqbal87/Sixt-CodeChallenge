//
//  UIView+Extension.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
import UIKit

extension UIView{
    
    func roundCorner(){
        
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
}
