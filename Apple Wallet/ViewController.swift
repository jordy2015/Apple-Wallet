//
//  ViewController.swift
//  ProjectTest
//
//  Created by Jordy Gonzalez on 10/31/20.
//

import UIKit
import PassKit

class ViewController: UIViewController {
  var paymentController: PKPaymentAuthorizationController?
  var paymentSuccess: Bool = false
  
  var buyWithApplePay: PKPaymentButton = {
    let btn = PKPaymentButton(paymentButtonType: .inStore, paymentButtonStyle: PKPaymentButtonStyle.black)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(buyChoes), for: .touchDown)
    return btn
  }()
  
  var addApplePass: PKAddPassButton = {
    let btn = PKAddPassButton(addPassButtonStyle: PKAddPassButtonStyle.black)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(buyWithApplePay)
    view.addSubview(addApplePass)
    buyWithApplePay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    buyWithApplePay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    addApplePass.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
    addApplePass.widthAnchor.constraint(equalToConstant: 250).isActive = true
    addApplePass.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
  
  @objc func buyChoes() {
    paymentSuccess = false
    let paymentRequest = PKPaymentRequest()
    paymentRequest.countryCode = "US"
    paymentRequest.currencyCode = "USD"
    paymentRequest.merchantIdentifier = "merchant.com.pivothealth.qa"
    paymentRequest.merchantCapabilities = .capability3DS
    paymentRequest.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Nike choes", amount: NSDecimalNumber(string: "200"))]
    callApplePayControllet(request: paymentRequest)
  }
  
  func callApplePayControllet(request: PKPaymentRequest) {
    let paymentController = PKPaymentAuthorizationController(paymentRequest: request)
    paymentController.delegate = self
    paymentController.present { (success) in
      if(!success){
        print("error in transaction")
      }
    }
    self.paymentController = paymentController
  }
}

extension ViewController: PKPaymentAuthorizationControllerDelegate {
  func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
    controller.dismiss {
      if(self.paymentSuccess) {
        print("payment completed")
        self.paymentSuccess = false
      }
    }
  }
  
  func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    self.paymentSuccess = true
    showAlert(message: "Thanks for buy")
    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
  }
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: "Apple pay", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "ok", style: .default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
}

