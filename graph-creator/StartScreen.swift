//
//  StartScreen.swift
//  Graph Creator
//
//  Created by Henry Robbins on 6/1/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import Foundation
import UIKit

class StartScreen: UIViewController {
    
    @IBAction func newDirectedGraph(_ sender: Any) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectedGraph") as UIViewController
        self.present(viewController, animated: false, completion: nil)
        
    }
    
    @IBAction func newUndirectedGraph(_ sender: Any) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UndirectedGraph") as UIViewController
        self.present(viewController, animated: false, completion: nil)
        
    }
}
