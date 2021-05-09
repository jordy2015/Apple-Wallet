//
//  ApplePassHandler.swift
//  Apple Wallet
//
//  Created by Jordy Gonzalez on 8/05/21.
//

import Foundation
import UIKit
import PassKit

class ApplePassHandler: NSObject, PKAddPassesViewControllerDelegate {
    private var pkPass: PKPass?
    private var passAdded: Bool = false
    
    override init() {
      super.init();
      let notification = NSNotification.Name(rawValue: PKPassLibraryNotificationName.PKPassLibraryDidChange.rawValue)
      NotificationCenter.default.addObserver(forName: notification, object: nil, queue: nil) { (notification) in
        guard let userInfo = notification.userInfo else {
          return
        }
        
        self.passAdded = userInfo.contains { (data) -> Bool in
          guard let key = data.key as? String else { return false }
          return ["PKPassLibraryAddedPassesUserInfo", "PKPassLibraryReplacementPassesUserInfo"].contains(key)
        }
      }
    }
    
    func displayApplePass(_ vc: UIViewController, data: Data) -> Bool {
      passAdded = false
        
      do {
        self.pkPass = try PKPass(data: data)
        guard let addPassViewController = PKAddPassesViewController(pass: self.pkPass!) else {
          return false;
        }
        
        addPassViewController.delegate = self
        
        vc.present(addPassViewController, animated: true)
      } catch {
        return false
      }
        return true
    }
    
    func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
      if !self.passAdded {
        controller.dismiss(animated: true, completion: nil)
        return
      }
      
      let alertController = UIAlertController(title: "", message: "Your ID Card was successfully added to the Apple Wallet", preferredStyle: .alert)
      
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        controller.dismiss(animated: true, completion: nil)
      }))
      
      controller.show(alertController, sender: nil)
    }
  }
