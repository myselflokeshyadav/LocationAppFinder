//
//  LanguageViewController.swift
//  LocationFinderApp
//
//  Created by Atul Bhaisare on 5/20/19.
//  Copyright © 2019 Atul Bhaisare. All rights reserved.
//

import UIKit
import Loki
class LanguageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueViewController = segue.destination as? UINavigationController {
            if let btn = sender as? UIButton {
                if btn.tag == 101{
                    if let item = LKManager.sharedInstance().languages[0] as? LKLanguage {
                        LKManager.sharedInstance().currentLanguage = item
                        UserDefaults.standard.set(item.code, forKey: KLanguagekey)
                    }
                    
                }else{
                    if let item = LKManager.sharedInstance().languages[1] as? LKLanguage {
                        LKManager.sharedInstance().currentLanguage = item
                        UserDefaults.standard.set(item.code, forKey: KLanguagekey)
                        
                    }
                    
                }
            }
            let rootViewcontroller = segueViewController.viewControllers.first as! SavedLocationsViewController
            self.navigationController?.pushViewController(rootViewcontroller, animated: false)
        }
    }
    
}
