//
//  FTBaseViewController.swift
//  Ardhi
//
//  Created by Alex Zdorovets on 9/16/15.
//  Copyright (c) 2015 Solutions 4 Mobility. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationWithColor(.white)
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        
    
    }
    
   func setupNavigationWithColor(_ color: UIColor) {
        let font = UIFont.systemFont(ofSize: 25)
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : font as Any]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    //MARK: - Modifiers
    
    override var title : String? {
        didSet {
            super.title = title?.uppercased()
        }
    }
    
   
   
}
