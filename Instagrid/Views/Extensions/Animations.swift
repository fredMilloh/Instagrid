//
//  Animations.swift
//  Instagrid
//
//  Created by fred on 26/08/2021.
//

import UIKit

extension UIView {
    
    func animation(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, animations: animations, completion: completion)
    }
}
