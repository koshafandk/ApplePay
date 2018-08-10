//
//  ViewController.swift
//  ApplePay
//
//  Created by Andrew Koshkin on 8/10/18.
//  Copyright © 2018 Brander. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController {
    private var paymentButton: PKPaymentButton!
    private var cardButton: PKPaymentButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addApplePayPaymentButtonToView()
        addCardPaymentButtonToView()
    }


    private func addApplePayPaymentButtonToView() {
        paymentButton = PKPaymentButton(paymentButtonType: .checkout, paymentButtonStyle: .black)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.addTarget(self, action: #selector(applePayButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(paymentButton)
        
        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    private func addCardPaymentButtonToView() {
        cardButton = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .black)
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        cardButton.addTarget(self, action: #selector(cardButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(cardButton)
        
        view.addConstraint(NSLayoutConstraint(item: cardButton, attribute: .centerX, relatedBy: .equal, toItem: paymentButton, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cardButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 50))
    }
    
    @objc private func applePayButtonTapped(sender: UIButton) {
        let paymentNetworks:[PKPaymentNetwork] = [.masterCard, .visa]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            
            request.merchantIdentifier = "merchant.com.applepay.name"
            request.countryCode = "US"
            request.currencyCode = "USD"
            request.supportedNetworks = paymentNetworks
            request.requiredShippingContactFields = [.name, .postalAddress]
            request.merchantCapabilities = [.capability3DS, .capabilityDebit]
            
            let tshirt = PKPaymentSummaryItem(label: "T-shirt", amount: NSDecimalNumber(decimal: 1.00), type: .final)
            let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(decimal: 1.00), type: .final)
            let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(decimal: 1.00), type: .final)
            let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal: 3.00), type: .final)
            request.paymentSummaryItems = [tshirt, shipping, tax, total]
            
            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            
            if let viewController = authorizationViewController {
                viewController.delegate = self
                
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func cardButtonTapped(sender: UIButton) {
//        let addCardVC = PKAddPaymentPassViewController(requestConfiguration: PKAddPaymentPassRequestConfiguration(encryptionScheme: .ECC_V2)!, delegate: nil)
//        present(addCardVC!, animated: true, completion: nil)
    }
}

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        //TODO: Request to processing service like Stripe
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss the Apple Pay UI
        dismiss(animated: true, completion: nil)
    }
}
