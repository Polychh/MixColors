//
//  UIViewControlle + ext.swift
//  MixColors
//
//  Created by Polina on 07.02.2024.
//

import UIKit
extension UIViewController{
    func asyncMain(_ action: @escaping () -> Void){
        DispatchQueue.main.async {
            action()
        }
    }
    
    func animation(duration: CGFloat, animate: @escaping () -> Void){
        UIView.animate(withDuration: duration) {
            animate()
        }
    }
}
