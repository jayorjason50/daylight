//
//  VCTab.swift
//  TableDemo
//
//  Created by Liam Chapman on 22/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//



import UIKit

class VCTab: UITabBarController, UITextFieldDelegate{

var user: AnyObject?

    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        println("viewController: \(viewController)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("User: \(user)")
    
    
    
    }
    
}

